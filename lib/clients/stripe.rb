require_relative './stripe/configuration'
require_relative './stripe/mock_client'
require_relative './stripe/mock_client/mock_end_point'
require_relative './stripe/client'
require_relative './error'

module Clients
  module Stripe
    class << self
      def client
        select_client.new
      end

      def configure
        yield configuration
      end

      def configuration
        @configuration ||= Configuration.new
      end

      private

      def select_client
        configuration.use_mock? ? MockClient : Client
      end
    end
  end
end
