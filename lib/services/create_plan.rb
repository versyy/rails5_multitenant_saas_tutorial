require 'services/base_service'
require 'services/error'

module Services
  class CreatePlan < BaseService
    Response = Struct.new(:success?, :plan, :stripe_plan, :errors)

    def initialize(plan_class:, stripe_create_plan_svc:, logger:)
      @plan_class = plan_class
      @stripe_create_plan_svc = stripe_create_plan_svc
      super(logger: logger)
    end

    # Plans define the  billing and pricing mechanisms for a Product;  Features
    # are defined in Product, whereas price/billing frequency/free trial
    # are defined within Plan
    #
    # plan_params = any viable params for Plan.create(params)
    #
    # returns: Response object
    def call(plan_params:)
      plan, stripe_plan = nil

      @plan_class.transaction do
        plan = @plan_class.create!(plan_params)
        stripe_plan = create_stripe_plan(plan)
        plan.update!(update_plan_params(stripe_plan))
      end
      create_response(true, plan, stripe_plan)
    rescue StandardError => e
      log_error(CreatePlanError.new(e))
      create_response(false, nil, nil)
    end

    private

    def update_plan_params(stripe_plan)
      {
        stripe_id:          stripe_plan.id,
        name:               stripe_plan.nickname,
        amount:             stripe_plan.amount,
        interval:           stripe_plan.interval,
        interval_count:     stripe_plan.interval_count,
        currency:           stripe_plan.currency,
        trial_period_days:  stripe_plan.trial_period_days
      }.compact
    end

    def create_stripe_plan(plan)
      result = @stripe_create_plan_svc.call(plan: plan)
      log_error(result.errors.first) unless result.errors.empty?
      raise CreatePlanError, "plan to stripe: #{plan.attributes}" unless result.success?
      result.record
    end

    def create_response(success, plan = nil, stripe_plan = nil)
      Response.new(success, plan, stripe_plan, errors)
    end
  end
end
