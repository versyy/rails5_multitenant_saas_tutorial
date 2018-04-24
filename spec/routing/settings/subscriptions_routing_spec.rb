require 'rails_helper'

RSpec.describe Settings::SubscriptionsController, type: :routing do
  describe 'routing' do
    let(:resource) { '/settings/subscriptions' }
    let(:resource_item) { resource + '/1' }
    let(:controller) { 'settings/subscriptions' }

    specify { expect(get:     resource).to      route_to(controller + '#index') }
    specify { expect(post:    resource).to      route_to(controller + '#create') }
    specify { expect(get:     resource_item).to route_to(controller + '#show', id: '1') }
    specify { expect(put:     resource_item).to route_to(controller + '#update', id: '1') }
    specify { expect(patch:   resource_item).to route_to(controller + '#update', id: '1') }
    specify { expect(delete:  resource_item).to route_to(controller + '#destroy', id: '1') }
  end
end
