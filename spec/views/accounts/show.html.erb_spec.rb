require 'rails_helper'

RSpec.describe 'accounts/show', type: :view do
  before(:each) { @account = assign(:account, create(:account)) }

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Company/)
    expect(rendered).to match(/Website/)
  end
end
