require 'rails_helper'
require 'services/create_payment_source'

RSpec.describe Services::CreatePaymentSource do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:payment_token) { 'token' }
  let(:user) { double(:user, stripe_id: nil, update!: true) }
  let(:pay_success) { true }
  let(:cus_success) { true }
  let(:errors) { [] }
  let(:pay_result) { double(:pay_result, success?: pay_success, record: nil, errors: errors) }
  let(:customer) { double(:customer, id: 'cus_1') }
  let(:cus_result) { double(:cus_result, success?: cus_success, errors: errors, record: customer) }
  let(:str_create_payment_source_svc) { double(:stripe_create_payment_source, call: pay_result) }
  let(:str_find_or_create_customer_svc) { double(:stripe_create_payment_source, call: cus_result) }
  let(:ctxt) do
    described_class.new(
      stripe_create_payment_source_svc: str_create_payment_source_svc,
      stripe_find_or_create_customer_svc: str_find_or_create_customer_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(user: user, payment_token: payment_token) }

    it { is_expected.to be_success }

    context 'when an error occurs' do
      let(:pay_success) { false }
      let(:errors) { [StandardError.new('error')] }

      it { is_expected.not_to be_success }

      it 'contains a CreatePaymentSourceError' do
        expect(subject.errors.first).to be_a(Services::CreatePaymentSourceError)
        expect(subject.errors.first.message).to eq('Unable to create payment source')
      end
    end
  end
end
