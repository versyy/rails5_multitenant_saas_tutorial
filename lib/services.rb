require 'services/error'
require 'services/create_plan'
require 'services/create_product'
require 'services/create_subscription'
require 'services/register_account'
require 'clients/stripe'

module Services
  class << self
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

    private

    def logger
      Rails.logger
    end
  end
end
