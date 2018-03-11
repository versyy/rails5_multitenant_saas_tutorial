require 'rails_helper'

RSpec.describe 'accounts/index', type: :view do
  before(:each) do
    assign(:accounts, [
             create(:account, website: 'https://www.example.com'),
             create(:account, website: 'https://www.google.com')
           ])
  end

  it 'renders a list of accounts' do
    render
    assert_select 'tr>td', text: 'Company', count: 2
    assert_select 'tr>td', text: 'https://www.example.com', count: 1
    assert_select 'tr>td', text: 'https://www.google.com', count: 1
  end
end
