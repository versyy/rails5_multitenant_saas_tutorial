require 'rails_helper'

RSpec.describe Plan, type: :model do
  let(:plan) { build(:plan) }
  subject { plan }

  it { is_expected.to be_valid }

  it 'has a subscriptions relationship' do
    expect(subject.subscriptions.count).to eq(0)
    expect(subject.subscriptions.respond_to?(:build)).to be
  end
end
