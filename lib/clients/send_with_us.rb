require_relative './send_with_us/configuration'
require_relative './send_with_us/mock_client'
require_relative './send_with_us/client'
require_relative './error'

module Clients
  module SendWithUs
    class << self
      def client
        select_client.new(opts: { verbose: configuration.verbose? })
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
