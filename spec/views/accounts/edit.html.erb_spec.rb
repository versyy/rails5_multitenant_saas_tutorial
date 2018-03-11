require 'rails_helper'

RSpec.describe 'accounts/edit', type: :view do
  before(:each) { @account = assign(:account, create(:account)) }

  it 'renders the edit account form' do
    render

    assert_select 'form[action=?][method=?]', account_path(@account), 'post' do
      assert_select 'input[name=?]', 'account[company]'
      assert_select 'input[name=?]', 'account[website]'
    end
  end
end
