require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let(:admin_user) { create(:user, :as_admin) }
  let(:owner_user) { create(:user, :as_owner) }
  let(:member_user) { create(:user, account: owner_user.account) }

  context 'when is an admin' do
    let(:first_user) { create(:user, :as_admin) }
    subject { Ability.new(admin_user) }
    it 'has permssion to access only the related account objects' do
      expect(subject).to     be_able_to(:manage, admin_user.account)
      expect(subject).to     be_able_to(:manage, owner_user)
      expect(subject).to     be_able_to(:manage, owner_user.account)
      expect(subject).to     be_able_to(:manage, admin_user.roles.first)
      expect(subject).to     be_able_to(:manage, owner_user.roles.first)
      expect(subject).to     be_able_to(:manage, member_user)
      expect(subject).to     be_able_to(:manage, member_user.account)
    end
  end

  context 'when is a owner' do
    subject { Ability.new(owner_user) }
    it 'has permssion to access only the related account objects' do
      expect(subject).to     be_able_to(:manage, owner_user.account)
      expect(subject).to     be_able_to(:manage, member_user)
      expect(subject).to     be_able_to(:manage, owner_user.roles.first)
      expect(subject).to     be_able_to(:manage, member_user.roles.first)
      expect(subject).not_to be_able_to(:read,   admin_user)
      expect(subject).not_to be_able_to(:read,   admin_user.account)
    end
  end

  context 'when is a member' do
    subject { Ability.new(member_user) }
    it 'has permission to read only the related account objects' do
      expect(subject).to     be_able_to(:read,   owner_user.account)
      expect(subject).to     be_able_to(:read,   owner_user)
      expect(subject).to     be_able_to(:read,   member_user.roles.first)
      expect(subject).not_to be_able_to(:manage, member_user.account)
      expect(subject).not_to be_able_to(:manage, member_user)
      expect(subject).not_to be_able_to(:manage, member_user.roles.first)
      expect(subject).not_to be_able_to(:read,   admin_user)
      expect(subject).not_to be_able_to(:read,   admin_user.account)
    end
  end
end
