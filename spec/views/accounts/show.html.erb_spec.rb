require 'rails_helper'

RSpec.describe 'accounts/show', type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(
                                  company: 'Company',
                                  website: 'Website'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Company/)
    expect(rendered).to match(/Website/)
  end
end
