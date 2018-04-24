require 'clients/stripe/base'

module Clients
  module Stripe
    class CreateProduct < Base
      def initialize(stripe_product_class:, logger:)
        @stripe_product_class = stripe_product_class
        super(logger: logger)
      end

      def call(product:)
        @logger.debug "Creating Stripe Product with #{create_params(product)}"
        stripe_product = @stripe_product_class.create(create_params(product))
        create_response(success: true, record: stripe_product)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: stripe_product)
      end

      private

      def create_params(product)
        {
          name:                 product.name,
          id:                   product.stripe_id,
          type:                 product.stripe_type,
          statement_descriptor: product.statement_descriptor,
          unit_label:           product.unit_label
        }
      end
    end
  end
end
