require 'lib_helper'

RSpec.describe Services::Stripe::SyncPlans do
  let(:logger) { double(:logger, debug: true) }
  let(:local_plan1) { double(:plan, stripe_id: 'a1a') }
  let(:local_plan2) { double(:plan, stripe_id: 'b2b') }
  let(:local_plans) { [local_plan1, local_plan2] }
  let(:stripe_plan1) { double(:stripe_plan1, id: 'a1a') }
  let(:stripe_plan2) { double(:stripe_plan2, id: 'a2a', delete: true) }
  let(:stripe_plans) { [stripe_plan1, stripe_plan2] }
  let(:plan_class) { class_double('Plan', all: local_plans) }
  let(:stripe_plan_class) { class_double('Stripe:Plan', all: stripe_plans, create: true) }
  let(:stripe_create_plan_svc) { double(:stripe_create_plan_svc, call: true) }
  let(:ctxt) do
    described_class.new(
      local_plan_class: plan_class,
      stripe_plan_class: stripe_plan_class,
      stripe_create_plan_svc: stripe_create_plan_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call }

    it { is_expected.to eq(true) }

    it 'calls create_stripe_plan_svc with correct value' do
      expect(stripe_create_plan_svc).to receive(:call).with(plan: local_plan2)
      subject
    end

    it 'calls delete on correct stripe plan' do
      expect(stripe_plan2).to receive(:delete)
      subject
    end
  end
end
