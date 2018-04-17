require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is invalid without password' do
    expect(build(:user, password: nil)).to be_invalid
  end

  context 'when user belongs to an account on creation' do
    let(:user) { create(:user) }
    it 'is assigned a member role on the account' do
      expect(user.has_role?(:member, user.account)).to be
    end
  end

  context 'when user does not belong to an acount on creation' do
    let(:user) { create(:user, account: nil) }
    it 'is not assigned any roles' do
      expect(user.roles.empty?).to be
    end
  end
end
