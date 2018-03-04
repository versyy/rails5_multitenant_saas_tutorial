require 'rails_helper'

RSpec.describe User, type: :model do
  let(:account) do
    Account.create(name: 'Name', website: 'www.example.com')
  end

  let(:valid_attributes) do
    { email: 'none@example.org', password: 'password' }
  end

  before(:each) do
    ActsAsTenant.current_tenant = account
  end

  it 'is valid with valid attributes' do
    expect(User.new(valid_attributes)).to be_valid
  end

  it 'is invalid without password' do
    expect(User.new(valid_attributes.merge({ password: nil }))).to be_invalid
  end
end
