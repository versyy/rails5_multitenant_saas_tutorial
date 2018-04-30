require 'rails_helper'

RSpec.describe 'settings/billing/index', type: :view do
  let(:user) { build(:user) }
  let(:plan) { build(:plan_with_fake_id) }
  let(:subscription) { build(:subscription_with_fake_id) }
  let(:valid_payment_source) { true }
  let(:current_plan) { nil }
  before(:each) do
    assign(:stripe_key, 'key')
    assign(:plans, [plan, plan])
    assign(:current_subscription, subscription)
    allow(subscription).to receive(:plans).and_return([current_plan])
    assign(:new_subscription_item, SubscriptionItem.new)
    assign(:valid_payment_source, valid_payment_source)
    allow(view).to receive(:current_user).and_return(user)
    render
  end

  it 'renders a list of plans' do
    assert_select 'tr>td', text: plan.name, count: 2
    assert_select 'tr>td', text: plan.amount.to_s, count: 2
    assert_select 'tr>td', text: plan.interval.to_s, count: 2
  end

  it 'does not mark any plan as current' do
    assert_select 'tr>td>b', text: 'Current', count: 0
  end

  it 'includes a form with an Update button to change plans' do
    assert_select 'form[action=?]', settings_subscription_path(subscription), count: 2 do
      assert_select 'input[type="submit"][value="Update"]', count: 2
    end
  end

  context 'when no valid payment source exists' do
    let(:valid_payment_source) { false }

    it 'includes the Stripe Checkout script' do
      assert_select 'script[class=?]', 'stripe-button', count: 2
    end
  end

  context 'when a plan is the current plan' do
    let(:current_plan) { plan }
    it 'marks it as current' do
      assert_select 'tr>td>b', text: 'Current', count: 2
    end
  end
end
