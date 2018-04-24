require 'clients/stripe/base'

module Clients
  module Stripe
    class CreatePaymentSource < Base
      def initialize(stripe_customer_class:, logger:)
        @stripe_customer_class = stripe_customer_class
        super(logger: logger)
      end

      def call(user:, payment_token:)
        raise CreatePaymentSourceError, 'Invalid Stripe ID' if user.stripe_id.nil?
        customer = find_stripe_customer(user)
        customer.source = payment_token
        customer.save
        create_response(success: true, record: customer.default_source)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: nil)
      end

      private

      def find_stripe_customer(user)
        @stripe_customer_class.retrieve(user.stripe_id)
      end
    end
  end
end
