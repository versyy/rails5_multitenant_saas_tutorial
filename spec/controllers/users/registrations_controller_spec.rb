require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:subject) { response }
  let(:user_attributes) { attributes_for(:user) }
  let(:account_attributes) { attributes_for(:account) }

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #new - /users/new' do
    before(:each) { get :new, session: valid_session }

    it { is_expected.to be_success }
  end

  describe 'POST #create - /users' do
    let(:attribs) { { user: user_attributes, account: account_attributes } }

    before(:each) { post :create, params: attribs, session: valid_session }
    after(:each) { ActsAsTenant.current_tenant = nil }

    context 'with valid params' do
      it 'creates a new Account' do
        account = Account.where(website: account_attributes[:website]).first
        expect(account.company).to eq(account_attributes[:company])
      end

      it 'creates a new User' do
        user = User.where(email: user_attributes[:email]).first
        expect(user.first_name).to eq(user_attributes[:first_name])
        expect(user.last_name).to eq(user_attributes[:last_name])
      end

      it { is_expected.to redirect_to(root_path) }
    end

    context 'with invalid User params' do
      let(:user_attributes) { attributes_for(:user, email: nil) }

      it { is_expected.to be_success }
    end

    context 'with invalid Account params' do
      let(:account_attributes) { { company: 'Company', website: 'bad-domain' } }

      it { is_expected.to be_success }
    end
  end

  describe 'PUT #update - /users' do
    let(:password) { Faker::Internet.password }
    let(:user) { create(:user, password: password) }
    let(:update_params) { { id: user.id, user: new_attributes } }

    before(:each) do
      ActsAsTenant.current_tenant = user.account
      sign_in user
      put :update, params: update_params, session: valid_session
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

      it { is_expected.to redirect_to(root_path) }
    end

    context 'with invalid params' do
      let(:new_attributes) { { first_name: 'New-Name' } }

      it { is_expected.to be_success }

      it 'does not update the requested account' do
        user.reload
        expect(user.first_name).not_to eq(new_attributes[:first_name])
      end
    end
  end
end
