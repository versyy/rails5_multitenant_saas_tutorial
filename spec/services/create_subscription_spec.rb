require 'rails_helper'
require 'lib_helper'
require 'services/create_subscription'

RSpec.describe Services::CreateSubscription do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:user) { instance_double('User', account: nil) }
  let(:subscription_class) { class_double('Subscription', create!: subscription) }
  let(:subscription) do
    instance_double('Subscription', id: 's_1', update!: true, subscription_items: sub_items)
  end
  let(:sub_items) { ActiveRecordHelpers::MockRelation.new(1, sub_item) }
  let(:sub_item) { instance_double('SubscriptionItem', id: 'si_1', save: true, update!: true) }
  let(:sub_params) { { subscription_items: [sub_item_params] } }
  let(:stripe_plan) { double(:stripe_plan, id: plan_id) }
  let(:stripe_sub_item) { double('Stripe::SubscriptionItem', plan: stripe_plan, id: 'sui_1') }
  let(:stripe_sub_items) { [stripe_sub_item] }
  let(:sub_item_params) { { plan_id: plan_id, quantity: 1 } }
  let(:plan_class) { class_double('Plan', find: plan) }
  let(:plan_id) { 'pla_1' }
  let(:plan) { instance_double('Plan', stripe_id: 'stripe_id_1') }
  let(:stripe_create_subscription_svc) do
    instance_double('Services::Stripe::CreateSubscription', call: result)
  end
  let(:success) { true }
  let(:result) { double(:result, success?: success, record: stripe_subscription, errors: []) }
  let(:stripe_subscription) do
    double(
      :stripe_subscription, id: 1, start: Time.now.to_i, items: stripe_sub_items, status: 'active'
    )
  end
  let(:ctxt) do
    described_class.new(
      subscription_class: subscription_class,
      plan_class: plan_class,
      stripe_create_subscription_svc: stripe_create_subscription_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  before(:each) do
    allow(sub_items).to receive(:where).with({ 'plans.stripe_id': plan_id }).and_return(sub_items)
  end

  describe '#call' do
    subject { ctxt.call(user: user, params: sub_params) }

    it { is_expected.to be_success }

    it 'returns the expected subscription' do
      expect(subject.subscription).to be(subscription)
    end

    it 'creates a new subscription' do
      expect(subscription_class).to receive(:create!).with(
        user: user, account: user.account, status: 'new'
      )
      subject
    end

    it 'creates new subscription items' do
      expect(sub_items).to receive(:build).with(
        plan_id: plan_id, quantity: 1
      ).and_return(sub_item)
      expect(sub_item).to receive(:save).with(no_args)
      subject
    end

    it 'returns the expected stripe_subscription' do
      expect(subject.stripe_subscription).to be(stripe_subscription)
    end

    it 'is expected to search for updatable SubscriptionItems by id' do
      expect(sub_items).to receive(:where).with({ 'plans.stripe_id': plan_id })
      subject
    end

    it 'is expected to update SubscriptionItem with a stripe_id' do
      expect(sub_item).to receive(:update!).with({ stripe_id: stripe_sub_item.id })
      subject
    end

    context 'when StripeCreateSubscription was not successful' do
      let(:success) { false }
      it { is_expected.not_to be_success }

      it 'contains a CreateSubscriptionError' do
        expect(subject.errors.first).to be_a(Services::CreateSubscriptionError)
        expect(subject.errors.first.message).to eq('')
      end
    end

    context 'when an unknown error occurs' do
      before(:each) do
        allow(stripe_create_subscription_svc).to(
          receive(:call).and_raise(StandardError.new('message'))
        )
      end
      it { is_expected.not_to be_success }

      it 'contains a CreateSubscriptionError' do
        expect(subject.errors.first).to be_a(Services::CreateSubscriptionError)
        expect(subject.errors.first.message).to eq('message')
      end
    end
  end
end
