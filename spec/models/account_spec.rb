require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:valid_attributes) do
    { name: 'Name', website: 'www.example.com' }
  end

  it 'is valid with valid attributes' do
    expect(Account.new(valid_attributes)).to be_valid
  end

  it 'is invalid with invalid website' do
    expect(
      Account.new(valid_attributes.merge({ website: 'invalid-domain' }))
    ).to be_invalid
  end

  it 'is invalid with duplicate website' do
    Account.create(valid_attributes)
    expect(Account.new(valid_attributes)).to be_invalid
  end

  it 'is invalid with missing name' do
    expect(Account.new({})).to be_invalid
  end
end
