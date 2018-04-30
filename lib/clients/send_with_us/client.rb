require 'clients/error'

module Clients
  module SendWithUs
    class Client
      class SendWithUsError < Clients::Error; end

      def initialize(opts: {})
        @verbose = opts[:verbose] || false
      end

      def deliver_msg(template_id:, to:, payload: {})
        email_client.send_email(template_id, to, data: payload)
      end

      private

      def email_client
        @email_client ||= ::SendWithUs::Api.new(debug: @verbose)
      rescue ::SendWithUs::Error => e
        raise SendWithUsError, e.message
      end
    end
  end
end
