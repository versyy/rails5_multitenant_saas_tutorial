require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  let(:subject) { response }

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET /resource/password/new' do
    before(:each) { get :new, session: valid_session }

    it { is_expected.to be_success }
  end

  describe 'POST /resource/password' do
    let(:user) { create(:user) }
    let(:reset_params) { { user: { email: user.email } } }
    before(:each) { post :create, params: reset_params, session: valid_session }

    it { is_expected.to redirect_to(new_user_session_path) }
  end

  describe 'GET /resource/password/edit' do
    let(:edit_params) { { reset_password_token: '112233' } }
    before(:each) { get :edit, params: edit_params, session: valid_session }

    it { is_expected.to be_success }
  end

  describe 'PUT /resource/password' do
    let(:user) { create(:user) }
    let(:update_params) do
      {
        reset_password_token: user.send_reset_password_instructions,
        password: 'password',
        password_confirmation: 'password'
      }
    end
    before(:each) { put :update, params: update_params, session: valid_session }

    it { is_expected.to be_success }
  end
end
