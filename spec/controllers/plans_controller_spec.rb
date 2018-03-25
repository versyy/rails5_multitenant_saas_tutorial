require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  let(:user) { create(:user, :as_admin) }
  let(:plan) { build(:plan_with_fake_id) }
  let(:valid_session) { {} }

  before(:each) do
    allow(Plan).to receive(:find).and_return(plan)
    allow(Plan).to receive(:all).and_return([plan])
    sign_in user
  end

  describe 'GET #index' do
    subject { get :index, params: {}, session: valid_session }
    it { is_expected.to be_success }
  end

  describe 'GET #show' do
    subject { get :show, params: { id: plan.id }, session: valid_session }
    it { is_expected.to be_success }
  end

  describe 'GET #new' do
    subject { get :new, params: {}, session: valid_session }
    before(:each) { allow(Product).to receive(:all).and_return([]) }
    it { is_expected.to be_success }
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: plan.id }, session: valid_session }
    it { is_expected.to be_success }
  end

  describe 'GET #create' do
    let(:plan_params) { { name: 'test' } }
    let(:result) { double(:result, success?: true, plan: plan) }
    let(:create_plan_svc) { instance_double('Services::CreatePlan', call: result) }
    subject { post :create, params: { plan: plan_params }, session: valid_session }

    before(:each) { allow(Services).to receive(:create_plan).and_return(create_plan_svc) }

    context 'with successful plan creation' do
      let(:result) { double(:result, success?: true, plan: plan) }
      it { is_expected.to redirect_to(plan) }
    end

    context 'with unsuccessful plan creation' do
      let(:result) { double(:result, success?: false, plan: plan) }
      let(:plan) { build(:plan) }
      it { is_expected.to be_success }
    end
  end

  describe 'PUT #update' do
    subject { put :update, params: { id: plan.id, plan: plan_params }, session: valid_session }
    let(:plan_params) { { active: false } }
    let(:success) { true }

    before(:each) do
      allow(plan).to receive(:update).and_return(success)
    end

    it 'has a edirect status code' do
      expect(subject).to have_http_status(302)
    end

    it { is_expected.to redirect_to(plan) }

    context 'when update fails' do
      let(:success) { false }

      it { is_expected.to have_http_status(200) }
    end
  end
end
