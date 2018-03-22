module Clients
  module Stripe
    class Configuration
      attr_accessor :use_mock, :verbose

      def initialize(opts = {})
        @use_mock = opts[:use_mock] || false
      end

      def use_mock?
        use_mock
      end
    end
  end
end
