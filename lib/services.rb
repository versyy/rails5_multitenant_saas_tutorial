require 'services/error'
require 'services/create_product'
require 'services/register_account'
require 'clients/stripe'

module Services
  class << self
    def create_product
      CreateProduct.new(
        product_class: ::Product,
        stripe_create_product_svc: Clients::Stripe.create_product,
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
