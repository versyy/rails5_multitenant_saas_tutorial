require 'rails_helper'
include DeviseHelpers # rubocop:disable Style/MixinUsage

RSpec.describe 'devise/registrations/edit', type: :view do
  let(:user) { create(:user) }

  it 'renders new account form' do
    render

    assert_select 'form[action=?][method=?]', user_registration_path, 'post' do
      assert_select 'input[name=?]', 'user[first_name]'
      assert_select 'input[name=?]', 'user[last_name]'
      assert_select 'input[name=?]', 'user[email]'
      assert_select 'input[name=?]', 'user[password]'
    end
  end
end
