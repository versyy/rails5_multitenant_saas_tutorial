module Clients
  module Stripe
    class MockClient
      class MockCustomer < MockEndPoint
        protected

        def standard_response
          { id: 'cus_1', email: 'a@b.com' }
        end
      end
    end
  end
end
