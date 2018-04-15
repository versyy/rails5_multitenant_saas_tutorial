require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { create(:user, :as_admin) }
  let(:product) { create(:product_with_fake_id) }
  let(:valid_session) { {} }
  subject { response }

  before(:each) { sign_in user }

  describe 'GET #index' do
    subject { get :index, params: {}, session: valid_session }
    before(:each) { allow(Product).to receive(:all).and_return([product]) }
    it { is_expected.to be_success }
  end

  describe 'GET #show' do
    subject { get :show, params: { id: product.id }, session: valid_session }
    before(:each) { allow(Product).to receive(:find).with(product.id).and_return(product) }
    it { is_expected.to be_success }
  end

  describe 'GET #new' do
    subject { get :new, params: {}, session: valid_session }
    it { is_expected.to be_success }
  end

  describe 'GET #edit' do
    before(:each) { get :edit, params: { id: product.id }, session: valid_session }
    before(:each) { allow(Product).to receive(:find).with(product.id).and_return(product) }
    it { is_expected.to be_success }
  end

  describe 'POST #create' do
    let(:product_params) do
      { name: 'name', description: 'desc', unit_label: 'label', statement_descriptor: 'hi' }
    end
    let(:result) { double(:result, success?: true, product: product) }
    let(:create_product_svc) { instance_double('Services::CreateProduct', call: result) }

    subject { post :create, params: { product: product_params }, session: valid_session }
    before(:each) { allow(Services).to receive(:create_product).and_return(create_product_svc) }

    it 'sends the expected params to Services::CreateProduct svc' do
      expect(create_product_svc).to receive(:call).with(
        product_params: hash_including(product_params)
      )
      subject
    end

    context 'with successful product creation' do
      let(:result) { double(:result, success?: true, product: product) }
      it { is_expected.to redirect_to(product) }
    end

    context 'with unsuccessful product creation' do
      let(:result) { double(:result, success?: false, product: product) }
      let(:plan) { build(:plan) }
      it { is_expected.to be_success }
    end
  end

  describe 'PUT #update' do
    let(:params) { { id: product.id, product: product_params } }
    let(:product_params) do
      { name: 'name', description: 'desc', unit_label: 'label', statement_descriptor: 'hi' }
    end
    let(:result) { double(:result, success?: true, product: product) }
    let(:update_product_svc) { instance_double('Services::UpdateProduct', call: result) }

    subject { put :update, params: params, session: valid_session }

    before(:each) { allow(Services).to receive(:update_product).and_return(update_product_svc) }

    it { is_expected.to redirect_to(product) }

    it 'sends the expected params to Services::UpdateProduct svc' do
      expect(update_product_svc).to receive(:call).with(
        product_id: product.id,
        params:     hash_including(product_params)
      )
      subject
    end

    context 'with successful product creation' do
      let(:result) { double(:result, success?: true, product: product) }
      it { is_expected.to redirect_to(product) }
    end

    context 'with unsuccessful product creation' do
      let(:result) { double(:result, success?: false, product: nil) }
      let(:plan) { build(:plan) }
      it { is_expected.to be_success }
    end
  end
end
