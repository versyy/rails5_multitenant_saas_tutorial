module Clients
  module Stripe
    class MockClient
      def customer
        MockCustomer
      end

      def plan
        MockPlan
      end

      def subscription
        MockSubscription
      end
    end
  end
end
