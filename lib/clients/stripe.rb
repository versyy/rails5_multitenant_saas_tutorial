module Clients
  module Stripe
    class << self
      private

      def logger
        Rails.logger
      end
    end
  end
end
