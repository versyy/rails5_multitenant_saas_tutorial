require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without password' do
    expect(build(:user, password: nil)).to be_invalid
  end
end
