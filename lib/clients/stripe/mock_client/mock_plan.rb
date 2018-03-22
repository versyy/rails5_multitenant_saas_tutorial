module Clients
  module Stripe
    class MockClient
      class MockPlan < MockEndPoint
        protected

        def standard_response
          {
            product:            'prod_1',
            id:                 'startup',
            nickname:           'startup',
            amount:             1000,
            currency:           'usd',
            interval:           'month',
            interval_count:     1,
            trial_period_days:  14
          }
        end
      end
    end
  end
end
