require 'rails_helper'

RSpec.describe WelcomeController, type: :routing do
  describe 'routing' do
    it 'routes root to welcome#index' do
      expect(get: '/').to route_to('welcome#index')
    end
  end
end
