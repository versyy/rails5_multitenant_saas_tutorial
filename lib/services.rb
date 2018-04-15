require 'services/error'
require 'services/cancel_subscription'
require 'services/create_payment_source'
require 'services/create_plan'
require 'services/create_product'
require 'services/create_subscription'
require 'services/register_account'
require 'services/update_product'
require 'services/update_subscription'
require 'services/verify_payment_source'
require 'clients/stripe'

module Services
  class << self
    def cancel_subscription
      CancelSubscription.new(
        subscription_class: ::Subscription,
        stripe_cancel_subscription_svc: Clients::Stripe.cancel_subscription,
        logger: logger
      )
    end

    def create_payment_source
      CreatePaymentSource.new(
        stripe_create_payment_source_svc: Clients::Stripe.create_payment_source,
        stripe_find_or_create_customer_svc: Clients::Stripe.find_or_create_customer,
        logger: logger
      )
    end

    def create_plan
      CreatePlan.new(
        plan_class: ::Plan,
        stripe_create_plan_svc: Clients::Stripe.create_plan,
        logger: logger
      )
    end

    def create_product
      CreateProduct.new(
        product_class: ::Product,
        stripe_create_product_svc: Clients::Stripe.create_product,
        logger: logger
      )
    end

    def create_subscription
      CreateSubscription.new(
        subscription_class: ::Subscription,
        plan_class: ::Plan,
        stripe_create_subscription_svc: Clients::Stripe.create_subscription,
        logger: logger
      )
    end

    def register_account
      RegisterAccount.new(
        account_class: ::Account,
        logger: logger
      )
    end

    def update_product
      UpdateProduct.new(
        product_class: ::Product,
        stripe_update_product_svc: Clients::Stripe.update_product,
        logger: logger
      )
    end

    def update_subscription
      UpdateSubscription.new(
        subscription_class: ::Subscription,
        plan_class: ::Plan,
        stripe_update_subscription_svc: Clients::Stripe.update_subscription,
        logger: logger
      )
    end

    def verify_payment_source
      VerifyPaymentSource.new(
        stripe_find_or_create_customer_svc: Clients::Stripe.find_or_create_customer,
        logger: logger
      )
    end

    private

    def logger
      Rails.logger
    end
  end
end
