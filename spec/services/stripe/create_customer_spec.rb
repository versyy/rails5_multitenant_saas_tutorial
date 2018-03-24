require 'lib_helper'

RSpec.describe Services::Stripe::CreateCustomer do
  let(:user) { double(:user, email: 'a@b.com', id: '23e8dd85-4680-4346-9f83-b3132f69b28c') }
  let(:stripe_customer) { double(:stripe_customer, id: 'cus_1') }
  let(:stripe_customer_class) { class_double('Stripe::Customer', create: stripe_customer) }
  let(:logger) { double(:logger, debug: true) }
  let(:ctxt) do
    described_class.new(stripe_customer_class: stripe_customer_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(user: user) }

    it { is_expected.to be_success }

    it 'calls stripe_customer_class#create' do
      expect(stripe_customer_class).to receive(:create).with(
        hash_including(:email, :meta_data)
      )
      subject
    end

    it 'returns the expected objects' do
      expect(subject.user).to eq(user)
      expect(subject.stripe_customer).to eq(stripe_customer)
    end
  end
end
