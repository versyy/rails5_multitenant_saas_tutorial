require 'rails_helper'

RSpec.describe WelcomeController, type: :routing do
  describe 'routing' do
    it 'root routes to welcome#index' do
      expect(get: '/').to route_to('welcome#index')
    end

    it 'routes to #index' do
      expect(get: '/welcome/index').to route_to('welcome#index')
    end
  end
end
