require 'clients/error'

module Clients
  module Stripe
    class Client
      class StripeError < Clients::Error; end

      def customer
        ::Stripe::Customer
      end

      def plan
        ::Stripe::Plan
      end

      def subscription
        ::Stripe::Subscription
      end
    end
  end
end
