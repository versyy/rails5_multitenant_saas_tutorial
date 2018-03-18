require 'versyy/communicator/error'

module Versyy
  module Communicator
    class Client
      class SendWithUsError < Versyy::Communicator::Error; end

      def initialize(opts: {})
        @verbose = opts[:verbose] || false
      end

      def deliver_msg(template_id:, to:, payload: {})
        email_client.send_email(template_id, to, payload)
      end

      private

      def email_client
        @email_client ||= ::SendWithUs::Api.new
      rescue ::SendWithUs::Error => e
        raise Versyy::Communicator::Client::SendWithUsError, e.message
      end
    end
  end
end
