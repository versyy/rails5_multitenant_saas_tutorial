require 'clients/stripe/response'

module Clients
  module Stripe
    class Base
      attr_accessor :errors, :logger

      def initialize(logger:)
        @logger = logger
        @errors = []
      end

      private

      def create_response(success:, record:)
        Response.new(success: success, record: record, errors: errors)
      end

      def log_error(err:)
        errors << err
        logger.fatal "#{self.class}: #{err.class}: #{err.message}"
      end
    end
  end
end
