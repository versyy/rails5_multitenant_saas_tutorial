require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:role)).to be_valid
  end

  it 'is valid with role_owner trait' do
    expect(build(:role_owner)).to be_valid
  end

  it 'is valid with role_member trait' do
    expect(build(:role_member)).to be_valid
  end
end
