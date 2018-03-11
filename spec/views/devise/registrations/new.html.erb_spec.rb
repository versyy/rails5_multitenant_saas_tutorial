require 'rails_helper'

RSpec.describe 'devise/registrations/new', type: :view do
  let(:user) { User.new }

  before do
    without_partial_double_verification do
      allow(view).to receive(:resource).and_return(User.new)
      allow(view).to receive(:resource_name).and_return(:user)
      allow(view).to receive(:devise_mapping).and_return(Devise.mappings[:user])
    end
  end

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
