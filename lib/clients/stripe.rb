require 'clients/stripe/cancel_subscription'
require 'clients/stripe/create_plan'
require 'clients/stripe/create_product'
require 'clients/stripe/create_subscription'

module Clients
  module Stripe
    class << self
      def cancel_subscription
        CancelSubscription.new(
          stripe_subscription_class: ::Stripe::Subscription,
          logger: logger
        )
      end

      def create_plan
        CreatePlan.new(
          stripe_plan_class: ::Stripe::Plan,
          logger: logger
        )
      end

      def create_product
        CreateProduct.new(
          stripe_product_class: ::Stripe::Product,
          logger: logger
        )
      end

      def create_subscription
        CreateSubscription.new(
          stripe_subscription_class: ::Stripe::Subscription,
          logger: logger
        )
      end

      private

      def logger
        Rails.logger
      end
    end
  end
end
