require 'rails_helper'

RSpec.describe Plan, type: :model do
  let(:plan) { build(:plan) }
  subject { plan }

  it { is_expected.to be_valid }
end
