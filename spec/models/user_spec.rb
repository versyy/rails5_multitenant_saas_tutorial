require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:first_user) { create(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is invalid without password' do
    expect(build(:user, password: nil)).to be_invalid
  end

  it 'is assigned the :owner role when it is the first user in an account' do
    expect(first_user.account.users.count).to eq(1)
    expect(first_user.has_role?(:owner, first_user.account)).to be
  end

  it 'is assigned the :member role when it is not the first user in an acccount' do
    second_user = create(:user, account: first_user.account)
    expect(second_user.has_role?(:owner, first_user.account)).not_to be
    expect(second_user.has_role?(:member, first_user.account)).to be
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
