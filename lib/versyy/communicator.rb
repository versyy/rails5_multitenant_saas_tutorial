require_relative './communicator/configuration'
require_relative './communicator/mock_client'
require_relative './communicator/client'
require_relative './communicator/error'

module Versyy
  module Communicator
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
