require 'rails_helper'

RSpec.describe Settings::SubscriptionsController, type: :controller do
  let(:user) { create(:user, :as_owner) }
  let(:format) { :html }
  let(:plan) { build(:plan_with_fake_id) }
  let(:result) { double(:result, success?: true) }
  let(:create_payment_source_svc) { instance_double('Services::CreatePaymentSource', call: result) }
  let(:sub) { build(:subscription_with_fake_id, account: user.account, user: user) }
  let(:valid_session) { {} }
  subject { response }

  before(:each) do
    allow(Services).to receive(:create_payment_source).and_return(create_payment_source_svc)
    sign_in user
  end

  # Need to clear out current tenant for each test case
  after(:each) { ActsAsTenant.current_tenant = false }

  describe 'GET #index' do
    before(:each) { get :index, params: {}, session: valid_session }
    it { is_expected.to be_success }
  end

  describe 'GET #show' do
    before(:each) do
      sub.save
      get :show, params: { id: sub.id }, session: valid_session
    end
    it { is_expected.to be_success }
  end

  describe 'POST #create' do
    let(:sub_attribs) { { plans: [{ id: plan.id, quantity: 1 }] } }
    let(:token) { 'token' }
    let(:success) { true }
    let(:result) { double(:result, success?: success, subscription: sub) }
    let(:create_subscription_svc) { instance_double('Services::CreateSubscription', call: result) }
    let(:create_params) { { subscription: sub_attribs, stripeToken: token }.compact }
    before(:each) do
      allow(Services).to receive(:create_subscription).and_return(create_subscription_svc)
      post :create, params: create_params, format: format, session: valid_session
    end
    it { is_expected.to redirect_to(settings_billing_index_path) }

    context 'when subscription unable to be created' do
      let(:success) { false }
      it { is_expected.to have_http_status(:bad_request) }
    end

    context 'when payment token is not provided' do
      let(:token) { nil }
      it { is_expected.to redirect_to(settings_billing_index_path) }
    end

    context 'when format is json' do
      let(:format) { :json }

      it { is_expected.to have_http_status(:ok) }
      specify { expect(JSON.parse(subject.body)).to include('id' => sub.id) }

      context 'and subscription is unable to be created' do
        let(:success) { false }
        it { is_expected.to have_http_status(:bad_request) }
      end
    end
  end

  describe 'PUT #update' do
    let(:plan_attribs) { { plan_id: plan.id, quantity: 1 } }
    let(:sub_attribs) { { subscription_items: [plan_attribs] } }
    let(:token) { 'token' }
    let(:success) { true }
    let(:result) { double(:result, success?: success, subscription: sub) }
    let(:update_subscription_svc) { instance_double('Services::UpdateSubscription', call: result) }
    let(:update_params) { { id: sub.id, subscription: sub_attribs, stripeToken: token }.compact }

    subject { put :update, params: update_params, format: format, session: valid_session }

    before(:each) do
      allow(Services).to receive(:update_subscription).and_return(update_subscription_svc)
    end

    it { is_expected.to redirect_to(settings_billing_index_path) }

    it 'sends valid params to update_subscription' do
      expect(update_subscription_svc).to receive(:call).with(
        hash_including(
          subscription_id: sub.id,
          params: hash_including(
            subscription_items: array_including(hash_including(:plan_id, :quantity))
          )
        )
      )
      subject
    end
    context 'when subscription unable to be update' do
      let(:success) { false }
      it { is_expected.to have_http_status(:bad_request) }
    end

    context 'when payment token is not provided' do
      let(:token) { nil }
      it { is_expected.to redirect_to(settings_billing_index_path) }
    end

    context 'when format is json' do
      let(:format) { :json }

      it { is_expected.to have_http_status(:ok) }
      specify { expect(JSON.parse(subject.body)).to include('id' => sub.id) }

      context 'and subscription is unable to be updated' do
        let(:success) { false }
        it { is_expected.to have_http_status(:bad_request) }
      end
    end
  end

  describe '#destroy' do
    let(:cancel_subscription_svc) { instance_double('Services::CancelSubscription', call: result) }
    let(:result) { double(:result, success?: success, subscription: sub) }
    let(:success) { true }

    before(:each) do
      allow(Services).to receive(:cancel_subscription).and_return(cancel_subscription_svc)
      delete :destroy, params: { id: sub.id }, format: format, session: valid_session
    end

    it { is_expected.to redirect_to(settings_billing_index_path) }

    context 'when subscription unable to be deleted' do
      let(:success) { false }
      it { is_expected.to have_http_status(:bad_request) }
    end

    context 'when format is json' do
      let(:format) { :json }

      it { is_expected.to have_http_status(:ok) }

      specify { expect(subject.body).to eq('') }

      context 'and subscription is unable to be deleted' do
        let(:success) { false }
        it { is_expected.to have_http_status(:bad_request) }
      end
    end
  end
end
