require 'rails_helper'

RSpec.describe 'plans/show', type: :view do
  before(:each) { @plan = assign(:plan, build(:plan, :with_fake_id)) }

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Stripe ID/)
    expect(rendered).to match(/Amount/)
    expect(rendered).to match(/Currency/)
    expect(rendered).to match(/Interval/)
    expect(rendered).to match(/Interval Count/)
    expect(rendered).to match(/Trial Period Days/)
    expect(rendered).to match(/Active/)
    expect(rendered).to match(/Displayable/)
  end
end
