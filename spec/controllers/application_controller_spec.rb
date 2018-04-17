require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      respond_to do |format|
        format.json { render json: { account_id: current_account.id }.to_json }
      end
    end
  end

  let(:account) { create(:account) }
  let(:valid_session) { { account_id: account.id } }

  describe 'GET #index' do
    before(:each) do
      ActsAsTenant.current_tenant = account
      get :index, format: :json, params: {}, session: valid_session
    end

    after(:each) { ActsAsTenant.current_tenant = nil }

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'returns valid json data' do
      payload = JSON.parse(response.body)
      expect(payload['account_id']).to eq(account.id)
    end
  end
end
