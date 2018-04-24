require 'spec_helper'
require 'clients/stripe/find_or_create_customer'

RSpec.describe Clients::Stripe::FindOrCreateCustomer do
  let(:user_id) { '23e8dd85-4680-4346-9f83-b3132f69b28c' }
  let(:stripe_id) { 'cus_1' }
  let(:user) { double(:user, email: 'a@b.com', id: user_id, stripe_id: stripe_id, update!: true) }
  let(:stripe_customer) { double(:stripe_customer, id: 'cus_1') }
  let(:retrieve_customer) { stripe_customer }
  let(:stripe_customer_class) do
    class_double('Stripe::Customer', create: stripe_customer, retrieve: retrieve_customer)
  end
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:ctxt) do
    described_class.new(stripe_customer_class: stripe_customer_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(user: user) }

    it { is_expected.to be_success }
    it { is_expected.to be_a(Clients::Stripe::Response) }

    context 'when user.stripe_id is nil' do
      let(:stripe_id) { nil }
      it 'calls stripe_customer_class#create' do
        expect(stripe_customer_class).to receive(:create).with(hash_including(:email, :metadata))
        subject
      end

      it { is_expected.to be_success }
    end

    it 'returns the expected objects' do
      expect(subject.record).to eq(stripe_customer)
    end

    context 'When an error occurs' do
      let(:stripe_customer_class) { nil }
      it { is_expected.not_to be_success }

      it 'has errors' do
        expect(subject.errors.count).to eq(1)
      end
    end
  end
end
