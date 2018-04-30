require 'spec_helper'
require 'clients/stripe/create_plan'

RSpec.describe Clients::Stripe::CreatePlan do
  let(:plan_attributes) do
    {
      product:            product,
      name:               'free',
      amount:             1000,
      interval:           'month',
      interval_count:     1,
      currency:           'usd',
      trial_period_days:  14
    }
  end
  let(:product) { double(:product, stripe_id: 'pr_1') }
  let(:local_plan) { double(:plan, plan_attributes) }
  let(:stripe_plan) { double(:stripe_plan) }
  let(:stripe_plan_class) { class_double('Stripe:Plan', create: stripe_plan) }
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:ctxt) do
    described_class.new(stripe_plan_class: stripe_plan_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(plan: local_plan) }

    it { is_expected.to be_success }

    it 'calls stripe_plan_class#create' do
      expect(stripe_plan_class).to receive(:create).with(
        hash_including(:nickname, :product, :amount, :interval, :interval_count, :currency)
      )
      subject
    end

    it 'returns the expected objects' do
      expect(subject.record).to eq(stripe_plan)
    end

    context 'When an error occurs' do
      let(:stripe_plan_class) { nil }
      it { is_expected.not_to be_success }

      it 'has errors' do
        expect(subject.errors.count).to eq(1)
      end
    end
  end
end
