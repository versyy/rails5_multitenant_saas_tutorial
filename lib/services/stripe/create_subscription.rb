module Services
  module Stripe
    class CreateSubscription
      def initialize(stripe_subscription_class:, logger:)
        @stripe_subscription_class = stripe_subscription_class
        @logger = logger
      end

      def call(subscription:)
        @logger.debug "Creating Stripe Subscription with #{create_params(subscription)}"
        stripe_sub = @stripe_subscription_class.create(create_params(subscription))
        create_response(true, subscription, stripe_sub)
      rescue StandardError => e
        create_response(false, nil, nil, log_message(e))
      end

      private

      def create_params(sub)
        {
          customer: sub.user.stripe_id,
          items: create_plans_params(sub.plans)
        }
      end

      def create_plans_params(plans)
        plans.map { |p| { plan: p.stripe_id } }
      end

      def log_message(err)
        msg = "#{self.class}: failed to complete; #{err.class}: #{err.message}"
        @logger.debug msg
        msg
      end

      def create_response(success, sub = nil, stripe_sub = nil, error_msg = nil)
        response = Struct.new(:success?, :subscription, :stripe_subscription, :eror_mmsg)
        response.new(success, sub, stripe_sub, error_msg)
      end
    end
  end
end
