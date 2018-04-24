require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:product) { build(:product_with_fake_id) }
  let(:plan) { build(:plan_with_fake_id, product: product) }

  describe '#currency_amount' do
    subject { helper.currency_amount(plan) }

    it { is_expected.to eq(10) }
  end

  describe '#currency_symbol' do
    subject { helper.currency_symbol(plan) }

    it { is_expected.to eq('$') }
  end

  describe '#interval' do
    subject { helper.interval(plan) }

    it { is_expected.to eq('/month per user') }
  end
end
