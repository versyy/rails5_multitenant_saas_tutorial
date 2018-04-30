require 'clients/stripe/base'

module Clients
  module Stripe
    class CreatePlan < Base
      def initialize(stripe_plan_class:, logger:)
        @stripe_plan_class = stripe_plan_class
        super(logger: logger)
      end

      def call(plan:)
        @logger.debug "Creating Stripe Plan with #{create_params(plan)}"
        stripe_plan = @stripe_plan_class.create(create_params(plan))
        create_response(success: true, record: stripe_plan)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: stripe_plan)
      end

      private

      def create_params(plan)
        {
          nickname:           plan.name,
          product:            plan.product.stripe_id,
          amount:             plan.amount,
          interval:           plan.interval,
          interval_count:     plan.interval_count,
          currency:           plan.currency,
          trial_period_days:  plan.trial_period_days
        }
      end
    end
  end
end
