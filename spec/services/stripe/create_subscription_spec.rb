require 'lib_helper'

RSpec.describe Services::Stripe::CreateSubscription do
  let(:subscription) { double(:subscription, user: user, plans: plans) }
  let(:user) { double(:user, stripe_id: 'cus_1') }
  let(:plans) { [plan, plan] }
  let(:plan) { double(:plan, stripe_id: 'plan_1') }
  let(:stripe_subscription) { double(:stripe_subscription, id: 'cus_1') }
  let(:stripe_subscription_class) do
    class_double('Stripe::Subscription', create: stripe_subscription)
  end
  let(:logger) { double(:logger, debug: true) }
  let(:ctxt) do
    described_class.new(stripe_subscription_class: stripe_subscription_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(subscription: subscription) }

    it { is_expected.to be_success }

    it 'calls stripe_subscription_class#create' do
      expect(stripe_subscription_class).to receive(:create)
      subject
    end

    it 'returns the expected objects' do
      expect(subject.subscription).to eq(subscription)
      expect(subject.stripe_subscription).to eq(stripe_subscription)
    end

    context 'When an error occurs' do
      let(:stripe_subscription_class) { nil }
      it { is_expected.not_to be_success }
    end
  end
end
