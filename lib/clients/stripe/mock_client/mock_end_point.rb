module Clients
  module Stripe
    class MockClient
      class MockEndPoint
        def create(_params = {}, _opts = {})
          respond(:create)
        end

        def delete(_params = {}, _opts = {})
          respond(:delete)
        end

        def save(_params = {}, _opts = {})
          respond(:save)
        end

        def update(_params = {}, _opts = {})
          respond(:update)
        end

        protected

        def respond(method)
          Hashie::Mash.new(send("#{method}_response"))
        end

        def create_response
          standard_response
        end

        def delete_response
          standard_response
        end

        def save_response
          standard_response
        end

        def update_response
          standard_response
        end

        def standard_response
          raise 'standard_response method must be overloaded in child class'
        end
      end
    end
  end
end
