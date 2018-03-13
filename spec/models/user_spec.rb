require 'rails_helper'

RSpec.describe User, type: :model do
  let(:first_user) { create(:user) }

  it 'is valid with valid attributes' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without password' do
    expect(build(:user, password: nil)).to be_invalid
  end

  it 'is assigned the :owner role when it is the first user in an account' do
    expect(first_user.account.users.count).to eq(1)
    expect(first_user.is_owner?).to be
  end

  it 'is assigned the :member role when it is not the first user in an acccount' do
    second_user = create(:user, account: first_user.account)
    expect(second_user.is_owner?).not_to be
    expect(second_user.is_member?).to be
  end
end
