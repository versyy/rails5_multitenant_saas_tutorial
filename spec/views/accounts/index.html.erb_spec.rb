require 'rails_helper'

RSpec.describe 'accounts/index', type: :view do
  before(:each) do
    assign(:accounts, [
             Account.create!(
               name: 'Name',
               website: 'www.example.com'
             ),
             Account.create!(
               name: 'Name',
               website: 'www.google.com'
             )
           ])
  end

  it 'renders a list of accounts' do
    render
    assert_select 'tr>td', text: 'Name', count: 2
    assert_select 'tr>td', text: 'www.example.com', count: 1
    assert_select 'tr>td', text: 'www.google.com', count: 1
  end
end
