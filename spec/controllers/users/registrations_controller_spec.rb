require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:user_attributes) { attributes_for(:user) }
  let(:account_attributes) do
    { company: 'Company', website: Faker::Internet.url(Faker::Internet.domain_name, '') }
  end

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:attribs) { { user: user_attributes, account: account_attributes } }

    before(:each) { post :create, params: attribs, session: valid_session }
    after(:each) { ActsAsTenant.current_tenant = nil }

    context 'with valid params' do
      it 'creates a new Account' do
        account = Account.where(website: account_attributes[:website]).first
        expect(account).to be
        expect(account.name).to eq(account_attributes[:company])
      end

      it 'creates a new User' do
        user = User.where(email: user_attributes[:email]).first
        expect(user).to be
        expect(user.first_name).to eq(user_attributes[:first_name])
        expect(user.last_name).to eq(user_attributes[:last_name])
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid user params' do
      let(:user_attributes) { attributes_for(:user, email: nil) }

      it 'returns a success response (i.e. to display the "new" template)' do
        expect(response).to be_success
      end
    end

    context 'with invalid account params' do
      let(:account_attributes) { { company: 'Company', website: 'bad-domain' } }
      it 'returns a success response (i.e. to display the "new" template)' do
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    let(:password) { Faker::Internet.password }
    let(:user) { create(:user, password: password) }

    before(:each) do
      ActsAsTenant.current_tenant = user.account
      sign_in user
      put :update,
          params: { id: user.id, user: new_attributes },
          session: valid_session
    end

    after(:each) { ActsAsTenant.current_tenant = nil }

    context 'with valid params' do
      let(:new_attributes) do
        { first_name: 'New-First', last_name: 'New-2nd', current_password: password }
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

      it 'does not update the requested account' do
        user.reload
        expect(user.first_name).not_to eq(new_attributes[:first_name])
      end
    end
  end
end
