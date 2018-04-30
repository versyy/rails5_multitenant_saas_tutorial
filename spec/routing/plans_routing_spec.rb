require 'rails_helper'

RSpec.describe PlansController, type: :routing do
  describe 'routing' do
    let(:controller) { 'plans' }
    let(:resource) { '/' + controller }
    let(:resource_item) { resource + '/1' }

    specify { expect(get:   resource).to                route_to(controller + '#index') }
    specify { expect(get:   resource + '/new').to       route_to(controller + '#new') }
    specify { expect(get:   resource_item).to           route_to(controller + '#show', id: '1') }
    specify { expect(get:   resource_item + '/edit').to route_to(controller + '#edit', id: '1') }
    specify { expect(post:  resource).to                route_to(controller + '#create') }
    specify { expect(put:   resource_item).to           route_to(controller + '#update', id: '1') }
    specify { expect(patch: resource_item).to           route_to(controller + '#update', id: '1') }
  end
end
