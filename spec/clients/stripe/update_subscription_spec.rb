require 'lib_helper'
require 'clients/stripe/update_subscription'

RSpec.describe Clients::Stripe::UpdateSubscription do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:subscription) do
    double(:subscription, stripe_id: 'id_1', subscription_items: sub_items)
  end
  let(:stripe_id) { 'ssi_1' }
  let(:existing_sub_item) { double(:sub_item, plan: plan, quantity: 1, stripe_id: stripe_id) }
  let(:new_sub_item) { double(:sub_item, plan: plan, quantity: 1, stripe_id: nil) }
  let(:sub_items) { ActiveRecordHelpers::MockRelation.new(1, existing_sub_item) }
  let(:plan) { double(:plan, stripe_id: 'plan_id_1') }
  let(:stripe_sub_items) { [stripe_sub_item, d_stripe_sub_item] }
  let(:stripe_sub_item) { double(:stripe_sub_item, id: 'ssi_1', plan: stripe_plan, quantity: 1) }
  let(:d_stripe_sub_item) { double(:stripe_sub_item, id: 'ssi_2', plan: stripe_plan, quantity: 1) }
  let(:stripe_plan) { double(:stripe_plan, id: 'plan_id_1') }
  let(:stripe_subscription) do
    double(:stripe_subscription, id: 'id_1', items: stripe_sub_items, save: true)
  end
  let(:stripe_subscription_class) do
    class_double('Stripe::Subscription', retrieve: stripe_subscription)
  end
  let(:ctxt) do
    described_class.new(stripe_subscription_class: stripe_subscription_class, logger: logger)
  end
  subject { ctxt }

  before(:each) do
    sub_items << new_sub_item
    allow(stripe_subscription).to receive(:items=).and_return(true)
  end

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(subscription: subscription) }

    it { is_expected.to be_success }

    it 'calls underlying API as expected' do
      expect(stripe_subscription_class).to receive(:retrieve)
      expect(stripe_subscription).to receive(:save)
      subject
    end

    it 'sets the subscription items as expected' do
      expect(stripe_subscription).to receive(:items=).with(
        [
          { id: existing_sub_item.stripe_id, quantity: existing_sub_item.quantity },
          { plan: new_sub_item.plan.stripe_id, quantity: new_sub_item.quantity },
          { id: d_stripe_sub_item.id, deleted: true }
        ]
      )
      subject
    end

    it 'does not delete any elements' do
      expect(stripe_sub_item).not_to receive(:delete)
      subject
    end

    it 'returns the expected stripe_subscription' do
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
