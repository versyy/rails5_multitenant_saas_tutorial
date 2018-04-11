require 'services/base_service'
require 'services/error'

module Services
  class CancelSubscription < BaseService
    Response = Struct.new(:success?, :subscription, :stripe_subscription, :errors)

    STATUS_CANCELLED = 'cancelled'.freeze

    def initialize(subscription_class:, stripe_cancel_subscription_svc:, logger:)
      @subscription_class             = subscription_class
      @stripe_cancel_subscription_svc = stripe_cancel_subscription_svc
      super(logger: logger)
    end

    # Cancels the subscription locally and with Stripe
    #
    # subscription_id:  '12345678-aaaa-bbbb-cccc-dddd-1234567890abcd'
    #
    # returns:          Response object
    def call(subscription_id:)
      subscription = @subscription_class.find(subscription_id)
      stripe_subscription = cancel_stripe_subscription(subscription)

      subscription.update!(status: STATUS_CANCELLED)

      self.success = true
      create_response(subscription, stripe_subscription)
    rescue StandardError => e
      log_error(CancelSubscriptionError.new(e))
      create_response(subscription, stripe_subscription)
    end

    private

    def cancel_stripe_subscription(sub)
      result = @stripe_cancel_subscription_svc.call(subscription: sub)
      raise CancelSubscriptionError, result.errors.map(&:message) unless result.success?
      result.record
    end

    def create_response(sub, stripe_sub)
      Response.new(success, sub, stripe_sub, errors)
    end
  end
end
