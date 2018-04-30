require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    it { is_expected.to have_http_status(:success) }

    context 'when user is logged in' do
      let(:user) { create(:user, :as_owner) }

      before(:each) { sign_in user }
      after(:each) { ActsAsTenant.current_tenant = nil }

      it { is_expected.to redirect_to(dashboard_path) }
    end
  end
end
