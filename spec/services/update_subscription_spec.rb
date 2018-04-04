require 'rails_helper'
require 'lib_helper'
require 'services/update_subscription'

RSpec.describe Services::UpdateSubscription do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:subscription_class) { class_double('Subscription', find: subscription) }
  let(:plan_class) { class_double('Plan', find: plan) }
  let(:sub_attribs) { { update!: true, id: '1', subscription_items: sub_items, reload: true } }
  let(:subscription) { instance_double('Subscription', sub_attribs) }
  let(:sub_params) { { subscription_items: [plan_params] } }
  let(:plan_params) { { plan_id: new_plan_id, quantity: 1 } }
  let(:new_plan_id) { 'pla_2' }
  let(:sub_items) { ActiveRecordHelpers::MockRelation.new(1, sub_item) }
  let(:sub_item) do
    instance_double('SubscriptionItem', update!: true, plan_id: plan_id, save: true, destroy: true)
  end
  let(:user) { instance_double('User', id: 'u_1', account: nil) }
  let(:plan_id) { 'pla_1' }
  let(:plan) { instance_double('Plan') }
  let(:result) { double(:result, success?: true, record: stripe_subscription) }
  let(:stripe_update_subscription_svc) do
    instance_double('Services::Stripe::UpdateSubscription', call: result)
  end
  let(:stripe_subscription) do
    double(:stripe_subscription, create: true, id: 1, start: Time.now.to_i, status: 'active')
  end
  let(:ctxt) do
    described_class.new(
      subscription_class: subscription_class,
      plan_class: plan_class,
      stripe_update_subscription_svc: stripe_update_subscription_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  before(:each) { allow(subscription).to receive(:transaction).and_yield }

  describe '#call' do
    subject { ctxt.call(subscription_id: subscription.id, params: sub_params) }

    it { is_expected.to be_success }

    it 'returns the expected subscription' do
      expect(subject.subscription).to be(subscription)
    end

    it 'returns the expected stripe_subscription' do
      expect(subject.stripe_subscription).to be(stripe_subscription)
    end

    it 'creates new subscription item' do
      expect(sub_items).to receive(:build).with(plan_params)
      subject
    end

    it 'deletes the subscription_item' do
      expect(sub_item).to receive(:destroy)
      subject
    end

    context 'when a plan already exists' do
      let(:new_plan_id) { 'pla_1' }
      it 'updates the subscription_item with new values' do
        expect(sub_item).to receive(:update!) # .with(plan_params)
        subject
      end
    end

    context 'when an unknown error occurs' do
      before(:each) do
        allow(subscription_class).to receive(:find).and_raise(StandardError.new('message'))
      end
      it { is_expected.not_to be_success }

      it 'contains a UpdateSubscriptionError' do
        expect(subject.errors.first).to be_a(Services::UpdateSubscriptionError)
        expect(subject.errors.first.message).to eq('message')
      end
    end
  end
end
