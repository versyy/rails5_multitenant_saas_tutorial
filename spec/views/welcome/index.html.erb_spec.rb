require 'rails_helper'

RSpec.describe 'welcome/index.html.erb', type: :view do
  let(:user) { User.new }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
  end

  context 'when current_user exists' do
    it 'renders links to key fields' do
      render
      assert_select 'div>a', text: 'sign_out', count: 1
    end
  end

  context 'when current_user does not exist' do
    let(:user) { nil }
    it 'renders links to key fields' do
      render
      assert_select 'div>a', text: 'sign_in', count: 1
      assert_select 'div>a', text: 'sign_up', count: 1
    end
  end
end
