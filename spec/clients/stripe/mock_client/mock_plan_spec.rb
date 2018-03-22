require 'lib_helper'

RSpec.describe Clients::Stripe::MockClient::MockPlan do
  let(:ctxt) { described_class.new }
  let(:params) { {} }
  subject { ctxt }

  it { is_expected.to be_a(described_class) }
  it { is_expected.to be_a(Clients::Stripe::MockClient::MockEndPoint) }

  describe '#create' do
    subject { ctxt.create(params) }
    it { is_expected.to be }

    it 'has key fields accessible' do
      expect(subject.id).to                 eq('startup')
      expect(subject.nickname).to           eq('startup')
      expect(subject.amount).to             eq(1000)
      expect(subject.currency).to           eq('usd')
      expect(subject.interval).to           eq('month')
      expect(subject.interval_count).to     eq(1)
      expect(subject.trial_period_days).to  eq(14)
    end
  end

  describe '#update' do
    subject { ctxt.update(params) }
    it { is_expected.to be }

    it 'has key fields accessible' do
      expect(subject.id).to                 eq('startup')
      expect(subject.nickname).to           eq('startup')
      expect(subject.amount).to             eq(1000)
      expect(subject.currency).to           eq('usd')
      expect(subject.interval).to           eq('month')
      expect(subject.interval_count).to     eq(1)
      expect(subject.trial_period_days).to  eq(14)
    end
  end
end
