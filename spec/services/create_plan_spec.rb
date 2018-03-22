require 'rails_helper'

RSpec.describe Services::CreatePlan do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:attribs) { attributes_for(:plan) }
  let(:plan) { instance_double('Plan', update!: true) }
  let(:plan_class) { class_double('Plan', create!: plan) }
  let(:stripe_create_plan_svc) { instance_double('Clients::Stripe::CreatePlan', call: result) }
  let(:result) { double(:result, success?: true, record: stripe_plan, errors: errors) }
  let(:stripe_plan_params) do
    {
      id: 'sp_1', nickname: 'a', amount: 1, interval: 'month', interval_count: 1, currency: 'usd',
      trial_period_days: 1
    }
  end
  let(:stripe_plan) { double(:stripe_plan, stripe_plan_params) }
  let(:errors) { [] }
  let(:ctxt) do
    described_class.new(
      plan_class: plan_class,
      stripe_create_plan_svc: stripe_create_plan_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(plan_params: attribs) }

    before(:each) { allow(plan_class).to receive(:transaction).and_yield }

    it { is_expected.to be_success }

    it 'returns the expected plan' do
      expect(subject.plan).to eq(plan)
    end

    it 'returns the expected stripe_plan' do
      expect(subject.stripe_plan).to be(stripe_plan)
    end

    context 'when an error occurs' do
      before(:each) do
        allow(plan_class).to receive(:create!).and_raise(StandardError.new('message'))
      end
      it { is_expected.not_to be_success }

      it 'contains a CreatePlanError' do
        expect(subject.errors.first).to be_a(Services::CreatePlanError)
        expect(subject.errors.first.message).to eq('message')
      end
    end
  end
end
