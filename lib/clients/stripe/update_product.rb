require 'clients/stripe/base'

module Clients
  module Stripe
    class UpdateProduct < Base
      def initialize(stripe_product_class:, logger:)
        @stripe_product_class = stripe_product_class
        super(logger: logger)
      end

      def call(product:)
        stripe_product = retrieve_product(product.stripe_id)
        @logger.debug "Updating Stripe Product with id:#{stripe_product.id}"
        stripe_product.name = product.name
        stripe_product.unit_label = product.unit_label
        stripe_product.statement_descriptor = product.statement_descriptor
        stripe_product.save

        create_response(success: true, record: stripe_product)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: stripe_product)
      end

      private

      def retrieve_product(id)
        @stripe_product_class.retrieve(id)
      end
    end
  end
end
