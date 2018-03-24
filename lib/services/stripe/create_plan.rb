module Services
  module Stripe
    class CreatePlan
      def initialize(stripe_plan_class:, logger:)
        @stripe_plan_class = stripe_plan_class
        @logger = logger
      end

      def call(plan:)
        @logger.debug "Creating Stripe Plan with #{create_params(plan)}"
        @stripe_plan_class.create(create_params(plan))
      end

      private

      def fetch_product_id
        ENV.fetch('STRIPE_PRODUCT_ID')
      end

      def create_params(plan)
        {
          id:                 plan.stripe_id,
          nickname:           plan.name,
          product:            fetch_product_id,
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
