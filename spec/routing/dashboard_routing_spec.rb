require 'rails_helper'

RSpec.describe DashboardController, type: :routing do
  describe 'routing' do
    let(:resource) { '/dashboard' }
    let(:controller) { 'dashboard' }
    specify { expect(get: resource).to route_to(controller + '#index') }
  end
end
