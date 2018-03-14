require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do
  let(:subject) { response }

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #confirmation/new' do
    before(:each) { get :new, session: valid_session }

    it { is_expected.to be_success }
  end

  describe 'POST #confirmation' do
    let(:user) { create(:user, confirmation_token: 'token') }
    let(:confirm_params) { { confirmation_token: user.confirmation_token } }
    before(:each) { post :create, params: confirm_params, session: valid_session }

    it { is_expected.to be_success }
  end

  describe 'GET #confirmation' do
    let(:user) { create(:user, confirmation_token: 'token') }
    let(:confirm_params) { { confirmation_token: user.confirmation_token } }
    before(:each) { get :show, params: confirm_params, session: valid_session }

    it { is_expected.to be_success }
  end
end
