require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:subject) { response }

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'with signed in account owner' do
    let(:user) { create(:user, :as_owner) }
    before(:each) { sign_in user }
    after(:each) { ActsAsTenant.current_tenant = nil }

    describe 'GET /resource/invitation/new' do
      before(:each) { get :new, session: valid_session }

      it { is_expected.to be_success }
    end

    describe 'POST /resource/invitation' do
      let(:invite_params) { { user: { email: 'test@example.org' } } }
      before(:each) { post :create, params: invite_params, session: valid_session }

      it { is_expected.to redirect_to(dashboard_path) }
    end
  end

  context 'with an invited user' do
    let(:user) { create(:user, confirmed_at: nil) }
    let(:invitation_token) { user.raw_invitation_token }
    before(:each) { user.deliver_invitation }

    describe 'GET /resource/invitation/accept' do
      let(:edit_params) { { invitation_token: invitation_token } }
      before(:each) { get :edit, params: edit_params, session: valid_session }

      it { is_expected.to be_success }
    end

    describe 'PUT /resource/invitation' do
      let(:update_params) do
        { user: {
          invitation_token: invitation_token,
          password: 'password',
          password_confirmation: 'password'
        } }
      end

      before(:each) { put :update, params: update_params, session: valid_session }

      it { is_expected.to redirect_to(dashboard_path) }
    end
  end
end
