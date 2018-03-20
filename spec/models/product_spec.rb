require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build(:product) }
  subject { product }

  it { is_expected.to be_valid }

  it 'has a valid plans association' do
    expect(subject.plans.count).to eq(0)
    expect(subject.plans.respond_to?(:build)).to be
  end
end
