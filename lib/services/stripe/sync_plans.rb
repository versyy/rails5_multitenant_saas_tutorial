module Services
  module Stripe
    class SyncPlans
      def initialize(local_plan_class:, stripe_plan_class:, stripe_create_plan_svc:, logger:)
        @local_plan_class = local_plan_class
        @stripe_plan_class = stripe_plan_class
        @stripe_create_plan_svc = stripe_create_plan_svc
        @logger = logger
      end

      def call
        stripe_plans = fetch_stripe_plans
        local_plans = fetch_local_plans

        remove_stripe_plans_missing_locally!(stripe_plans, local_plans)
        add_missing_stripe_plans_existing_locally!(stripe_plans, local_plans)

        true
      end

      private

      def create_stripe_plan(plan:)
        @stripe_create_plan_svc.call(plan: plan)
      end

      def remove_stripe_plans_missing_locally!(stripe_plans, local_plans)
        stripe_plans.each do |sp|
          unless local_plans.find { |lp| lp.stripe_id == sp.id }
            @logger.debug "deleting Stripe plan #{sp.id}"
            sp.delete
          end
        end
      end

      def add_missing_stripe_plans_existing_locally!(stripe_plans, local_plans)
        local_plans.each do |lp|
          unless stripe_plans.find { |sp| sp.id == lp.stripe_id }
            @logger.debug "creating Stripe plan from local plan #{lp.stripe_id}"
            create_stripe_plan(plan: lp)
          end
        end
      end

      def fetch_local_plans
        plans = @local_plan_class.all
        @logger.debug "#{plans.count} local plans found"
        plans
      end

      def fetch_stripe_plans
        plans = @stripe_plan_class.all
        puts "#{plans.count} stripe plans found" if @verbose
        plans
      end
    end
  end
end
