require 'clients/send_with_us/configuration'
require 'clients/send_with_us/mock_client'
require 'clients/send_with_us/client'
require 'clients/error'

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
