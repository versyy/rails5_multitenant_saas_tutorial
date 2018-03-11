require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Account. As you add validations to Account, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'Name', website: 'http://www.example.com' }
  end

  let(:invalid_attributes) do
    { name: 'Name', website: 'invalid-domain' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AccountsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      Account.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      account = Account.create! valid_attributes
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
      account = Account.create! valid_attributes
      get :edit, params: { id: account.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
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
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { account: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'New-Name' }
      end

      it 'updates the requested account' do
        account = Account.create! valid_attributes
        put :update,
            params: { id: account.to_param, account: new_attributes },
            session: valid_session
        account.reload
        expect(account.name).to eq(new_attributes[:name])
      end

      it 'redirects to the account' do
        account = Account.create! valid_attributes
        put :update,
            params: { id: account.to_param, account: valid_attributes },
            session: valid_session
        expect(response).to redirect_to(account)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        account = Account.create! valid_attributes
        put :update,
            params: { id: account.to_param, account: invalid_attributes },
            session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested account' do
      account = Account.create! valid_attributes
      expect do
        delete :destroy,
               params: { id: account.to_param },
               session: valid_session
      end.to change(Account, :count).by(-1)
    end

    it 'redirects to the accounts list' do
      account = Account.create! valid_attributes
      delete :destroy, params: { id: account.to_param }, session: valid_session
      expect(response).to redirect_to(accounts_url)
    end
  end
end
