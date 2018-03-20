require 'rails_helper'

RSpec.describe SubscriptionItem, type: :model do
  let(:sub_item) { build(:subscription_item) }
  subject { sub_item }

  it { is_expected.to be_valid }

  it 'has plan and subscription associations' do
    expect(subject.plan).to be_a(Plan)
    expect(subject.subscription).to be_a(Subscription)
  end
end
