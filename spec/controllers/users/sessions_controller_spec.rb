require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:subject) { response }

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #sign_in' do
    before(:each) { get :new, session: valid_session }

    it { is_expected.to be_success }
  end

  describe 'POST #sign_in' do
    let(:password) { 'password' }
    let(:user) { create(:user, password: password) }
    let(:login_params) { { user: { email: user.email, password: password } } }
    before(:each) { post :create, params: login_params, session: valid_session }

    it { is_expected.to redirect_to(root_url) }
  end

  describe 'DELETE #sign_out' do
    before(:each) { delete :destroy, session: valid_session }

    it { is_expected.to redirect_to(root_url) }
  end
end
