require 'services/base_service'
require 'services/error'

module Services
  class CreateSubscription < BaseService
    Response = Struct.new(:success?, :subscription, :stripe_subscription, :errors)

    STATUS_NEW = 'new'.freeze

    def initialize(subscription_class:, plan_class:, stripe_create_subscription_svc:, logger:)
      @subscription_class             = subscription_class
      @plan_class                     = plan_class
      @stripe_create_subscription_svc = stripe_create_subscription_svc
      super(logger: logger)
    end

    # Subscriptions define the billing relationship between an account and the
    # associated plans.
    #
    # user:   current_user # <= typically, although any user
    # params: {
    #   subscription_items: [
    #     {
    #      plan_id:  '12345678-aaaa-bbbb-cccc-dddd-1234567890abcd','
    #       quantity: 1
    #     }
    #   ]
    # }
    #
    # response: Response Object
    def call(user:, params:)
      subscription = create_subscription(user, params)

      stripe_subscription = create_stripe_subscription(subscription)
      update_subscription(subscription, stripe_subscription)

      self.success = true
      create_response(subscription, stripe_subscription)
    rescue StandardError => e
      log_error(CreateSubscriptionError.new(e))
      create_response(nil, nil)
    end

    private

    def create_subscription(user, sub_params)
      sub = @subscription_class.create!(user: user, account: user.account, status: STATUS_NEW)
      create_subscription_items(sub, sub_params[:subscription_items])
    end

    def create_subscription_items(sub, sub_items)
      sub_items.each do |item|
        sub_item = sub.subscription_items.build(item)
        sub_item.save
      end
      sub
    end

    def update_subscription(sub, stripe_sub)
      sub.update!(
        stripe_id:  stripe_sub.id,
        started_at: Time.at(stripe_sub.start),
        status:     stripe_sub.status
      )
      update_subscription_items(sub, stripe_sub)
      sub
    end

    def update_subscription_items(sub, stripe_sub)
      stripe_sub.items.each do |item|
        sub.subscription_items
           .joins(:plan)
           .where('plans.stripe_id': item.plan.id)
           .first
           .update!({ stripe_id: item.id })
      end
    end

    def create_stripe_subscription(sub)
      result = @stripe_create_subscription_svc.call(subscription: sub)
      raise CreateSubscriptionError, result.errors.map(&:message).join('; ') unless result.success?
      result.record
    end

    def create_response(sub = nil, stripe_sub = nil)
      Response.new(success, sub, stripe_sub, errors)
    end
  end
end
