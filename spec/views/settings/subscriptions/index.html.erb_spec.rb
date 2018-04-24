require 'rails_helper'

RSpec.describe 'settings/subscriptions/index', type: :view do
  let(:sub) { create(:subscription) }
  before(:each) { assign(:subscriptions, [sub, sub]) }

  it 'renders a list of subscriptions' do
    render
    assert_select 'tr>td', text: sub.id, count: 2
    assert_select 'tr>td', text: sub.user.name, count: 2
    assert_select 'tr>td', text: sub.started_at.to_s, count: 2
    assert_select 'tr>td', text: sub.status, count: 2
  end
end
