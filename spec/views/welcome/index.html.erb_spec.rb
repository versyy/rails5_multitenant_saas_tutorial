require 'rails_helper'

RSpec.describe 'welcome/index.html.erb', type: :view do
  let(:plan) { build(:plan_with_fake_id) }
  before(:each) { assign(:plans, [plan, plan, plan]) }

  it 'renders Introduction header with Sign-up link ' do
    render
    assert_select 'header a', text: 'Sign up', count: 1
  end

  it 'renders pricing-section with 3 plans' do
    render
    assert_select '.pricing-section span.currency', text: '$', count: 3
    assert_select '.pricing-section span.amount', text: '10', count: 3
    assert_select '.pricing-section div.interval', text: '/month per user', count: 3
    assert_select '.pricing-section a', text: 'Sign up', count: 3
  end
end
