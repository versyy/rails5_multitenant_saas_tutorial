require 'rails_helper'

RSpec.describe 'accounts/new', type: :view do
  before(:each) { assign(:account, build(:account)) }

  it 'renders new account form' do
    render

    assert_select 'form[action=?][method=?]', accounts_path, 'post' do
      assert_select 'input[name=?]', 'account[company]'

      assert_select 'input[name=?]', 'account[website]'
    end
  end
end
