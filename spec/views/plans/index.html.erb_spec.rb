require 'rails_helper'

RSpec.describe 'plans/index', type: :view do
  let(:plan) { build(:plan, :with_fake_id) }
  before(:each) { assign(:plans, [plan, plan]) }

  it 'renders a list of plans' do
    render
    assert_select 'tr>td', text: plan.name, count: 2
    assert_select 'tr>td', text: plan.stripe_id, count: 2
    assert_select 'tr>td', text: plan.amount.to_s, count: 2
    assert_select 'tr>td', text: plan.interval.to_s, count: 2
    assert_select 'tr>td', text: true.to_s, count: 4 # find both active and displayable fields
  end
end
