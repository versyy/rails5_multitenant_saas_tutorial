require 'rails_helper'

RSpec.describe 'accounts/index', type: :view do
  before(:each) do
    assign(:accounts, [
             Account.create!(
               company: 'Company',
               website: 'Website'
             ),
             Account.create!(
               company: 'Company',
               website: 'Website'
             )
           ])
  end

  it 'renders a list of accounts' do
    render
    assert_select 'tr>td', text: 'Company'.to_s, count: 2
    assert_select 'tr>td', text: 'Website'.to_s, count: 2
  end
end
