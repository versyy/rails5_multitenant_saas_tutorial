require 'rails_helper'

RSpec.describe 'settings/subscriptions/show', type: :view do
  let(:sub) { build(:subscription_with_fake_id) }
  before(:each) { assign(:subscription, sub) }

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(sub.account.company)
    expect(rendered).to match(sub.user.name)
    expect(rendered).to match(sub.status)
    expect(rendered).to match(sub.started_at.to_s)
    expect(rendered).to match(sub.stripe_id)
  end
end
