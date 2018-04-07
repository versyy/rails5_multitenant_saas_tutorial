require 'clients/stripe/create_plan'
require 'clients/stripe/create_product'

module Clients
  module Stripe
    class << self
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

      private

      def logger
        Rails.logger
      end
    end
  end
end
