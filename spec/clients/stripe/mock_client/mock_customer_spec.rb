require 'lib_helper'

RSpec.describe Clients::Stripe::MockClient::MockCustomer do
  let(:ctxt) { described_class.new }
  let(:params) { {} }
  subject { ctxt }

  it { is_expected.to be_a(described_class) }
  it { is_expected.to be_a(Clients::Stripe::MockClient::MockEndPoint) }

  describe '#create' do
    subject { ctxt.create(params) }
    it { is_expected.to be }

    it 'has key fields accessible' do
      expect(subject.id).to     eq('cus_1')
      expect(subject.email).to  eq('a@b.com')
    end
  end

  describe '#update' do
    subject { ctxt.update(params) }
    it { is_expected.to be }

    it 'has key fields accessible' do
      expect(subject.id).to     eq('cus_1')
      expect(subject.email).to  eq('a@b.com')
    end
  end
end
