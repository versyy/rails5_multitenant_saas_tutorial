require 'lib_helper'
require 'stripe'

RSpec.describe Clients::Stripe::Client do
  let(:ctxt) { described_class.new }

  describe '#customer' do
    subject { ctxt.customer }
    it { is_expected.to be(::Stripe::Customer) }
  end

  describe '#plan' do
    subject { ctxt.plan }
    it { is_expected.to be(::Stripe::Plan) }
  end

  describe '#subscription' do
    subject { ctxt.subscription }
    it { is_expected.to be(::Stripe::Subscription) }
  end
end
