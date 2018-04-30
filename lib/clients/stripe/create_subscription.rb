require 'clients/stripe/base'

module Clients
  module Stripe
    class CreateSubscription < Base
      def initialize(stripe_subscription_class:, logger:)
        @stripe_subscription_class = stripe_subscription_class
        super(logger: logger)
      end

      def call(subscription:)
        @logger.debug "Creating Stripe Subscription with #{create_params(subscription)}"
        stripe_sub = create_subscription(subscription)
        create_response(success: true, record: stripe_sub)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: stripe_sub)
      end

      private

      def create_subscription(sub)
        @stripe_subscription_class.create(create_params(sub), create_options(sub))
      end

      def create_options(sub)
        { idempotency_key: sub.idempotency_key }
      end

      def create_params(sub)
        {
          customer: sub.user.stripe_id,
          items:    create_items_params(sub.subscription_items),
          metadata: { subscription_id: sub.id }
        }
      end

      def create_items_params(sub_items)
        sub_items.map do |sub_item|
          {
            plan:     sub_item.plan.stripe_id,
            quantity: sub_item.quantity
          }
        end
      end
    end
  end
end
