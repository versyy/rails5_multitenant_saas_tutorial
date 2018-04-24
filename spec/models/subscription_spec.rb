require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:sub) { build(:subscription) }
  subject { sub }

  it { is_expected.to be_valid }

  it 'has valid belongs_to associations' do
    expect(subject.account).to be_a(Account)
    expect(subject.user).to be_a(User)
  end

  it 'has valid plan assocations' do
    expect(subject.plans.count).to eq(0)
    expect(subject.plans.respond_to?(:build)).to be
  end
end
