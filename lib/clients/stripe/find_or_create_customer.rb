require 'clients/stripe/base'

module Clients
  module Stripe
    class FindOrCreateCustomer < Base
      def initialize(stripe_customer_class:, logger:)
        @stripe_customer_class = stripe_customer_class
        super(logger: logger)
      end

      def call(user:)
        customer = find_or_create_customer(user)
        create_response(success: true, record: customer)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: customer)
      end

      private

      def find_or_create_customer(user)
        if user.stripe_id.nil?
          create_stripe_customer(create_params(user))
        else
          @stripe_customer_class.retrieve(user.stripe_id)
        end
      end

      def create_stripe_customer(user_params)
        @logger.debug "Creating Stripe Customer with params: #{user_params}"
        @stripe_customer_class.create(user_params)
      end

      def create_params(user)
        { email: user.email, metadata: { user_id: user.id } }
      end
    end
  end
end
