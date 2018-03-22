module Clients
  module Stripe
    class MockClient
      class MockSubscription < MockEndPoint
        protected

        def standard_response
          { id: 'sub_1', start: Time.now.to_i, status: 'active' }
        end
      end
    end
  end
end
