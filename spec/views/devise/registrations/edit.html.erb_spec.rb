require 'rails_helper'

RSpec.describe 'devise/registrations/edit', type: :view do
  let(:user) { User.new }

  before do
    allow(view).to receive(:resource).and_return(User.new)
    allow(view).to receive(:resource_name).and_return(:user)
    allow(view).to receive(:devise_mapping).and_return(Devise.mappings[:user])
  end

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
