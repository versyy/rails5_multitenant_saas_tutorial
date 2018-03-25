require 'lib_helper'
require 'services/verify_payment_source'

RSpec.describe Services::VerifyPaymentSource do
  let(:user) { double(:user, stripe_id: 'cus_1') }
  let(:stripe_find_or_create_customer_svc) do
    instance_double('Stripe::FindOrCreateCustomer', call: response)
  end
  let(:response) { double(:response, success?: true, record: customer) }
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:source_id) { 'src_1' }
  let(:customer) { double(:customer, id: 'cus_1', default_source: source_id) }
  let(:ctxt) do
    described_class.new(
      stripe_find_or_create_customer_svc: stripe_find_or_create_customer_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(user: user) }

    context 'when default source exists' do
      it { is_expected.to be_success }
    end

    context 'when the customer can not be found or created' do
      let(:customer) { nil }
      it { is_expected.not_to be_success }

      it 'contains an InvalidPaymentToken error' do
        expect(subject.errors.first).to be_a(Services::VerifyPaymentTokenError)
        expect(subject.errors.first.message).to match(/Customer not found/)
      end
    end

    context 'when their is no default source' do
      let(:source_id) { nil }
      it { is_expected.not_to be_success }

      it 'contains an InvalidPaymentToken error' do
        expect(subject.errors.first).to be_a(Services::InvalidPaymentTokenError)
        expect(subject.errors.first.message).to eq('Card is Missing')
      end
    end

    context 'when an error occurs' do
      before(:each) do
        allow(customer).to receive(:default_source).and_raise(StandardError.new('error'))
      end
      it { is_expected.not_to be_success }

      it 'contains a VerifyPaymentTokenError' do
        expect(subject.errors.first).to be_a(Services::VerifyPaymentTokenError)
        expect(subject.errors.first.message).to eq('error')
      end
    end
  end
end
