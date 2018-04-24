require 'rails_helper'
require 'lib_helper'
require 'services/cancel_subscription'

RSpec.describe Services::CancelSubscription do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:subscription_class) { class_double('Subscription', find: subscription) }
  let(:subscription) { instance_double('Subscription', update!: true, id: '1') }
  let(:result) { double(:result, success?: true, record: stripe_subscription) }
  let(:stripe_cancel_subscription_svc) do
    instance_double('Services::Stripe::CancelSubscription', call: result)
  end
  let(:stripe_subscription) { double(:stripe_subscription, id: 1, status: 'cancelled') }

  let(:ctxt) do
    described_class.new(
      subscription_class: subscription_class,
      stripe_cancel_subscription_svc: stripe_cancel_subscription_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(subscription_id: subscription.id) }

    it { is_expected.to be_success }

    it 'returns the expected subscription' do
      expect(subject.subscription).to be(subscription)
    end

    it 'returns the expected stripe_subscription' do
      expect(subject.stripe_subscription).to be(stripe_subscription)
    end

    it 'sets the subscription status to "cancelled"' do
      expect(subscription).to receive(:update!).with({ status: 'cancelled' })
      subject
    end

    context 'when an unknown error occurs' do
      before(:each) do
        allow(subscription_class).to receive(:find).and_raise(StandardError.new('message'))
      end
      it { is_expected.not_to be_success }

      it 'contains a CancelSubscriptionError' do
        expect(subject.errors.first).to be_a(Services::CancelSubscriptionError)
        expect(subject.errors.first.message).to eq('message')
      end
    end
  end
end
