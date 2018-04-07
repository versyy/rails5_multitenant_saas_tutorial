require 'rails_helper'
require 'clients/stripe/create_payment_source'

RSpec.describe Clients::Stripe::CreatePaymentSource do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:payment_token) { 'token' }
  let(:user) { double(:user, stripe_id: 'cus_1') }
  let(:stripe_customer) { double(:stripe_customer, default_source: 'src_1') }
  let(:stripe_customer_class) { class_double('Stripe::Customer', retrieve: stripe_customer) }
  let(:ctxt) do
    described_class.new(
      stripe_customer_class: stripe_customer_class,
      logger: logger
    )
  end
  subject { ctxt }

  before(:each) do
    allow(stripe_customer).to receive(:source=).and_return(true)
    allow(stripe_customer).to receive(:save).and_return(true)
  end

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(user: user, payment_token: payment_token) }

    it { is_expected.to be_success }

    it 'has no errors' do
      expect(subject.errors).to eq([])
    end

    it 'sets the source and saves it' do
      expect(stripe_customer).to receive(:source=).with(payment_token)
      expect(stripe_customer).to receive(:save)
      subject
    end

    context 'when an error occurs' do
      before(:each) do
        allow(stripe_customer).to receive(:save).and_raise(StandardError.new('error'))
      end

      it { is_expected.not_to be_success }

      it 'has errors' do
        expect(subject.errors.count).to eq(1)
      end
    end
  end
end
