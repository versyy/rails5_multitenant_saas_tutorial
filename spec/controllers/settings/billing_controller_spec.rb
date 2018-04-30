require 'rails_helper'

RSpec.describe Settings::BillingController, type: :controller do
  let(:user) { create(:user, :as_owner) }
  let(:plan) { create(:plan) }
  let(:valid_session) { {} }
  let(:verify_payment_source_svc) { instance_double('Services::VerifyPaymentSource', call: result) }
  let(:result) { double(:result, success?: success) }
  let(:success) { true }

  before(:each) do
    allow(Services).to receive(:verify_payment_source).and_return(verify_payment_source_svc)
    sign_in user
  end

  # Need to clear out current tenant for each test case
  after(:each) { ActsAsTenant.current_tenant = false }

  describe 'GET #index' do
    subject { get :index, params: {}, session: valid_session }

    it { is_expected.to be_success }

    context 'when no payment source exists' do
      let(:success) { false }
      it { is_expected.to be_success }
    end
  end
end
