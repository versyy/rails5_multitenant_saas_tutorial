require 'lib_helper'

RSpec.describe Clients::Stripe::MockClient do
  let(:ctxt) { described_class.new }

  describe '#customer' do
    subject { ctxt.customer }
    it { is_expected.to be(described_class::MockCustomer) }
  end

  describe '#plan' do
    subject { ctxt.plan }
    it { is_expected.to be(described_class::MockPlan) }
  end

  describe '#subscription' do
    subject { ctxt.subscription }
    it { is_expected.to be(described_class::MockSubscription) }
  end
end
