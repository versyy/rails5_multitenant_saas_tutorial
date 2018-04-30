module Clients
  module Stripe
    class Response
      attr_reader :record, :errors

      def initialize(success:, record:, errors: [])
        @success = success
        @record = record
        @errors = errors
      end

      def success?
        @success
      end
    end
  end
end
