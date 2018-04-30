require 'rails_helper'
require 'clients/stripe/create_subscription'

RSpec.describe Clients::Stripe::CreateSubscription do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:subscription) do
    instance_double(
      'Subscription', id: 's_1', user: user, subscription_items: sub_items, idempotency_key: 'key'
    )
  end
  let(:user) { double(:user, stripe_id: 'cus_1') }
  let(:sub_items) { [sub_item] }
  let(:sub_item) { double(:sub_item, id: 'si_1', plan: plan, quantity: 1) }
  let(:plan) { double(:plan, id: 'p_1', stripe_id: 'plan_1') }
  let(:stripe_plan) { double(:stripe_plan, id: plan.stripe_id) }
  let(:stripe_item) { double(:stripe_item, save: true, plan: stripe_plan) }
  let(:stripe_items) { [stripe_item] }
  let(:stripe_subscription) { double(:stripe_subscription, id: 'cus_1', items: stripe_items) }
  let(:stripe_subscription_class) do
    class_double('Stripe::Subscription', create: stripe_subscription)
  end
  let(:ctxt) do
    described_class.new(stripe_subscription_class: stripe_subscription_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(subscription: subscription) }

    before(:each) { allow(stripe_item).to receive(:metadata=) }

    it { is_expected.to be_success }

    it 'calls stripe_subscription_class#create' do
      expect(stripe_subscription_class).to receive(:create)
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
