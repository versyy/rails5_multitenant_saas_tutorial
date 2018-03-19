module Versyy
  module Communicator
    class Configuration
      attr_accessor :use_mock, :verbose

      def initialize(opts = {})
        @use_mock = opts[:use_mock] || false
        @verbose = opts[:verbose] || false
      end

      def use_mock?
        use_mock
      end

      def verbose?
        @verbose
      end
    end
  end
end
