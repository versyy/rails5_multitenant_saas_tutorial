module Services
  module Stripe
    class CreateCustomer
      def initialize(stripe_customer_class:, logger:)
        @stripe_customer_class = stripe_customer_class
        @logger = logger
      end

      def call(user:)
        @logger.debug "Creating Stripe Customer with #{create_params(user)}"
        customer = @stripe_customer_class.create(create_params(user))
        create_response(true, user, customer)
      rescue StandardError => e
        create_response(false, nil, nil, log_message(e))
      end

      private

      def create_params(user)
        {
          email:      user.email,
          meta_data:  { user_id: user.id }
        }
      end

      def log_message(err)
        msg = "#{self.class}: failed to complete; #{err.class}: #{err.message}"
        @logger.debug msg
        msg
      end

      def create_response(success, user = nil, stripe_customer = nil, error_msg = nil)
        response = Struct.new(:success?, :user, :stripe_customer, :eror_mmsg)
        response.new(success, user, stripe_customer, error_msg)
      end
    end
  end
end
