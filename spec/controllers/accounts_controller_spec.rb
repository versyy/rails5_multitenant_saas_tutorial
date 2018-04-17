require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { create(:user) }
  let(:account) { user.account }

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) { sign_in user }

  # Need to clear out current tenant for each test case
  after(:each) { ActsAsTenant.current_tenant = false }

  describe 'GET #index' do
    it 'returns a success response' do
      account
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: account.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: account.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { attributes_for(:account) }

      it 'creates a new Account' do
        expect do
          post :create, params: { account: valid_attributes }, session: valid_session
        end.to change(Account, :count).by(1)
      end

      it 'redirects to the created account' do
        post :create, params: { account: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Account.order(created_at: :desc).first)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { attributes_for(:account, website: 'invalid-website') }

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { account: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:valid_attributes) { attributes_for(:account, company: 'NewCompany') }

      it 'updates the requested account' do
        put :update,
            params: { id: account.to_param, account: valid_attributes },
            session: valid_session
        account.reload
        expect(account.company).to eq(valid_attributes[:company])
      end

      it 'redirects to the account' do
        put :update,
            params: { id: account.to_param, account: valid_attributes },
            session: valid_session
        expect(response).to redirect_to(account)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { attributes_for(:account, company: nil, website: 'Invalid-Domain') }
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update,
            params: { id: account.to_param, account: invalid_attributes },
            session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:account) { create(:account) }
    before(:each) { account } # ensure account is created

    it 'destroys the requested account' do
      expect do
        delete :destroy,
               params: { id: account.to_param },
               session: valid_session
      end.to change(Account, :count).by(-1)
    end

    it 'redirects to the accounts list' do
      delete :destroy, params: { id: account.to_param }, session: valid_session
      expect(response).to redirect_to(accounts_url)
    end
  end
end
