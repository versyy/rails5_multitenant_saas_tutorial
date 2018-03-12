require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:role)).to be_valid
  end

  it 'supports an Account resource' do
    expect(build(:role_with_account).resource).to be_a(Account)
  end
end
