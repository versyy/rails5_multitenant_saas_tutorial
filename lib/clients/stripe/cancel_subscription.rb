require 'clients/stripe/base'

module Clients
  module Stripe
    class CancelSubscription < Base
      def initialize(stripe_subscription_class:, logger:)
        @stripe_subscription_class = stripe_subscription_class
        super(logger: logger)
      end

      def call(subscription:, immediately: true)
        @logger.debug "Canceling Stripe Subscription with id:#{subscription.stripe_id}"
        stripe_sub = @stripe_subscription_class.retrieve(subscription.stripe_id)
        stripe_sub.delete(at_period_end: !immediately)
        create_response(success: true, record: stripe_sub)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: stripe_sub)
      end
    end
  end
end
