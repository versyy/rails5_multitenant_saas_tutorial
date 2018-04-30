require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:user, :as_owner) }
  let(:valid_session) { {} }

  describe 'GET #index' do
    subject { get :index, params: {}, session: valid_session }

    context 'when user signed in' do
      before(:each) { sign_in user }
      after(:each) { ActsAsTenant.current_tenant = false }

      it { is_expected.to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'when user not signed in' do
      it { is_expected.not_to be_success }
      it { is_expected.to have_http_status(302) }
    end
  end
end
