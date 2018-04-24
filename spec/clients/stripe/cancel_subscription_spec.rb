require 'spec_helper'
require 'clients/stripe/cancel_subscription'

RSpec.describe Clients::Stripe::CancelSubscription do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:subscription) { double(:subscription, stripe_id: 'id_1') }
  let(:stripe_subscription) { double(:stripe_subscription, id: 'id_1', delete: true) }
  let(:stripe_subscription_class) do
    class_double('Stripe::Subscription', retrieve: stripe_subscription)
  end
  let(:ctxt) do
    described_class.new(stripe_subscription_class: stripe_subscription_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(subscription: subscription) }

    it { is_expected.to be_success }

    it 'calls underlying API as expected' do
      expect(stripe_subscription_class).to receive(:retrieve).with(subscription.stripe_id)
      expect(stripe_subscription).to receive(:delete).with(at_period_end: false)
      subject
    end

    it 'returns the expected objects' do
      expect(subject.record).to eq(stripe_subscription)
    end

    context 'When an error occurs' do
      let(:stripe_subscription_class) { nil }
      it { is_expected.not_to be_success }

      it 'has errors' do
        expect(subject.errors.count).to eq(1)
      end
    end
  end
end
