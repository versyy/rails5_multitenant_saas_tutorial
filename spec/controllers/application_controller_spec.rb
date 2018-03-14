require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    respond_to :json

    def index
      authorize! :index, current_user
      render json: { account_id: current_account.id }.to_json
    end
  end

  let(:user) { create(:user) }
  let(:valid_session) { {} }

  describe 'GET #index' do
    before(:each) do
      ActsAsTenant.current_tenant = user.account
      sign_in user
      get :index, format: :json, params: {}, session: valid_session
    end

    after(:each) { ActsAsTenant.current_tenant = nil }

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'returns valid json data' do
      payload = JSON.parse(response.body)
      expect(payload['account_id']).to eq(user.account.id)
    end
  end
end
