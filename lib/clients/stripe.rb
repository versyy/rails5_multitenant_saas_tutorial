require 'clients/stripe/cancel_subscription'
require 'clients/stripe/create_payment_source'
require 'clients/stripe/create_plan'
require 'clients/stripe/create_product'
require 'clients/stripe/create_subscription'
require 'clients/stripe/find_or_create_customer'
require 'clients/stripe/update_product'
require 'clients/stripe/update_subscription'

module Clients
  module Stripe
    class << self
      def cancel_subscription
        CancelSubscription.new(
          stripe_subscription_class: ::Stripe::Subscription,
          logger: logger
        )
      end

      def create_payment_source
        CreatePaymentSource.new(
          stripe_customer_class: ::Stripe::Customer,
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

      def find_or_create_customer
        FindOrCreateCustomer.new(
          stripe_customer_class: ::Stripe::Customer,
          logger: logger
        )
      end

      def update_product
        UpdateProduct.new(
          stripe_product_class: ::Stripe::Product,
          logger: logger
        )
      end

      def update_subscription
        UpdateSubscription.new(
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
