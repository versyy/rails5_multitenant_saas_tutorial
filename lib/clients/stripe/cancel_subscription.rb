require 'clients/stripe/base'

module Clients
  module Stripe
    class CancelSubscription < Base
      def initialize(stripe_subscription_class:, logger:)
        @stripe_subscription_class = stripe_subscription_class
        super(logger: logger)
      end

      def call(subscription:, immediately: true)
        @logger.debug "Canceling Stripe Subscription with id:#{subscription.stripe_subscription_id}"
        stripe_sub = retrieve_subscription(subscription.stripe_subscription_id)
        stripe_sub.delete(!immediately)
        create_response(success: true, record: stripe_sub)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: stripe_sub)
      end

      private

      def retrieve_subscription(id)
        @stripe_subscription_class.retrieve(id)
      end
    end
  end
end
