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

  context '#safe_attributes' do
    subject { user.safe_attributes }

    it { is_expected.to be_a(Hash) }
    it { is_expected.to include(first_name: user.first_name) }
    it { is_expected.to include(last_name: user.last_name) }
    it { is_expected.to include(email: user.email) }
    it { is_expected.to include(last_sign_in_at: user.last_sign_in_at) }
    it { is_expected.to include(updated_at: user.updated_at) }
    it { is_expected.to include(created_at: user.created_at) }
  end
end
