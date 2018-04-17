require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:subject) { response }
  let(:user_attributes) { attributes_for(:user) }
  let(:account_attributes) { attributes_for(:account) }
  let(:account) { instance_double('Account', attributes: {}) }
  let(:success) { true }
  let(:register_account_svc) { double(:register_account_svc, call: register_result) }
  let(:register_result) { double(:register_result, success?: success, account: account) }

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new - /users/new' do
    before(:each) { get :new, session: valid_session }

    it { is_expected.to be_success }
  end

  describe 'POST #create - /users' do
    let(:attribs) { { user: user_attributes, account: account_attributes } }
    subject { post :create, params: attribs, session: valid_session }

    context 'with valid params' do
      it 'submits to Services.register_account.call()' do
        expect(Services).to receive(:register_account).and_call_original
        subject
      end

      it 'creates a new User' do
        subject
        user = User.where(email: user_attributes[:email]).first
        expect(user.first_name).to eq(user_attributes[:first_name])
        expect(user.last_name).to eq(user_attributes[:last_name])
      end

      it { is_expected.to redirect_to(root_path) }
    end

    context 'with invalid User params' do
      let(:user_attributes) { attributes_for(:user, email: nil) }

      it 'does not submit to Services.register_account.call()' do
        expect(Services).not_to receive(:register_account)
        subject
      end

      it { is_expected.to be_success }

      it 'does not create an Account' do
        expect { subject }.not_to(change { Account.count })
      end
    end

    context 'with invalid Account params' do
      let(:account_attributes) { { company: 'Company', website: 'bad-domain' } }
      let(:success) { false }

      it { is_expected.to be_success }

      it 'submits to Services.register_account.call()' do
        expect(Services).to receive(:register_account).and_call_original
        subject
      end

      it 'does not create an Account' do
        expect { subject }.not_to(change { Account.count })
      end

      it 'does not create a User' do
        expect { subject }.not_to(change { User.count })
      end
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
