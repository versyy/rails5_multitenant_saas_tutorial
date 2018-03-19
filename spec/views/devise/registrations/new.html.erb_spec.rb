require 'rails_helper'
include DeviseHelpers # rubocop:disable Style/MixinUsage

RSpec.describe 'devise/registrations/new', type: :view do
  let(:user) { User.new }

  it 'renders new account form' do
    render

    assert_select 'form[action=?][method=?]', user_registration_path, 'post' do
      assert_select 'input[name=?]', 'user[first_name]'
      assert_select 'input[name=?]', 'user[last_name]'
      assert_select 'input[name=?]', 'user[email]'
      assert_select 'input[name=?]', 'user[password]'
      assert_select 'input[name=?]', 'account[company]'
      assert_select 'input[name=?]', 'account[website]'
    end
  end
end
