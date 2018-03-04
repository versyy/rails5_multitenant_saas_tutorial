require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      respond_to do |format|
        format.json { render json: { account_id: current_account.id }.to_json }
      end
    end
  end

  let(:account_id) { 'e5ea6e3e-dc54-49cf-9111-f423c3c719d1' }
  let(:valid_attributes) { { id: account_id, name: 'Name', website: 'www.example.com' } }
  let(:valid_session) { { account_id: account_id } }

  describe 'GET #index' do
    before(:each) do
      Account.create! valid_attributes
      get :index, format: :json, params: {}, session: valid_session
    end

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'returns valid json data' do
      payload = JSON.parse(response.body)
      expect(payload['account_id']).to eq(account_id)
    end
  end
end
