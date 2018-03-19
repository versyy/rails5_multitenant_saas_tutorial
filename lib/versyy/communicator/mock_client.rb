module Versyy
  module Communicator
    class MockClient
      Response = Struct.new(:code, :message, :body)

      def initialize(opts: {})
        @verbose = opts[:verbose] || false
      end

      def deliver_msg(template_id:, to:, payload: {})
        output_msg(template_id, to, payload) if verbose?
        Response.new('200', 'OK', build_body(template_id, to, payload))
      end

      private

      def build_body(template_id, to, payload)
        {
          template_id: template_id,
          to: to,
          payload: payload
        }.to_json
      end

      def output_msg(template_id, to, payload)
        puts "\nSent Msg to: #{to}; template_id; #{template_id}"
        puts "\n\t#{payload}"
      end

      def verbose?
        @verbose
      end
    end
  end
end
