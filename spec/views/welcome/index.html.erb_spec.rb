require 'rails_helper'

RSpec.describe 'welcome/index.html.erb', type: :view do
  context 'when current_user exists' do
    let(:user) { create(:user) }
    before(:each) { sign_in user }
    after(:each) { ActsAsTenant.current_tenant = nil }

    it 'renders links to key fields' do
      render
      assert_select 'div>a', text: 'sign_out', count: 1
    end
  end

  context 'when current_user does not exist' do
    it 'renders links to key fields' do
      render
      assert_select 'div>a', text: 'sign_in', count: 1
      assert_select 'div>a', text: 'sign_up', count: 1
    end
  end
end
