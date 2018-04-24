require 'rails_helper'

RSpec.describe Settings::BillingController, type: :routing do
  describe 'routing' do
    let(:resource) { '/settings/billing' }
    let(:resource_item) { resource + '/1' }
    let(:controller) { 'settings/billing' }
    specify { expect(get: resource).to route_to(controller + '#index') }
  end
end
