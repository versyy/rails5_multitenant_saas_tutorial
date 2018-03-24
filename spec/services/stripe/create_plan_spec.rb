require 'lib_helper'

RSpec.describe Services::Stripe::CreatePlan do
  let(:plan_attributes) do
    {
      stripe_id:          'pla_1',
      name:               'free',
      amount:             1000,
      interval:           'month',
      interval_count:     1,
      currency:           'usd',
      trial_period_days:  14
    }
  end
  let(:local_plan) { double(:plan, plan_attributes) }
  let(:stripe_plan_class) { class_double('Stripe:Plan', create: true) }
  let(:logger) { double(:logger, debug: true) }
  let(:ctxt) do
    described_class.new(stripe_plan_class: stripe_plan_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(plan: local_plan) }

    it 'calls stripe_plan_class#create' do
      expect(stripe_plan_class).to receive(:create).with(
        hash_including(:id, :nickname, :product, :amount, :interval, :interval_count, :currency)
      )
      subject
    end
  end
end
