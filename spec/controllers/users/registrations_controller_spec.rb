require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:user_attributes) do
    {
      first_name: 'First Name',
      last_name: 'Last Name',
      email: 'email@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:account_attributes) { { company: 'Company', website: 'www.example.com' } }
    let(:valid_attributes) { { user: user_attributes, account: account_attributes } }
    let(:invalid_attributes) do
      valid_attributes[:user][:email] = nil
      valid_attributes
    end

    context 'with valid params' do
      before(:each) do
        post :create, params: valid_attributes, session: valid_session
      end

      it 'creates a new Account' do
        account = Account.where(website: valid_attributes[:account][:website]).first
        expect(account).to be
        expect(account.name).to eq(account_attributes[:company])
      end

      it 'creates a new User' do
        user = User.where(email: valid_attributes[:user][:email]).first
        expect(user).to be
        expect(user.first_name).to eq(user_attributes[:first_name])
        expect(user.last_name).to eq(user_attributes[:last_name])
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "new" template)' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        post :create, params: invalid_attributes, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    login_user

    let(:user) { User.order(created_at: :desc).first } # finding user created by login_user

    before(:each) do
      put :update,
          params: { id: user.id, user: new_attributes },
          session: valid_session
    end

    context 'with valid params' do
      let(:new_attributes) do
        { first_name: 'New-First', last_name: 'New-2nd', current_password: 'password' }
      end

      it 'updates the requested account' do
        user.reload
        expect(user.first_name).to eq(new_attributes[:first_name])
        expect(user.last_name).to eq(new_attributes[:last_name])
      end

      it 'redirects to the account' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      let(:new_attributes) { { first_name: 'New-Name' } }

      it "returns a success response (i.e. to display the 'edit' template)" do
        expect(response).to be_success
      end
    end
  end
end
