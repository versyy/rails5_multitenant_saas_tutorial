require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let(:admin_user) { create(:user, :as_admin) }
  let(:owner_user) { create(:user, :as_owner) }
  let(:member_user) { create(:user, account: owner_user.account) }
  let(:owner_sub) { create(:subscription, account: owner_user.account, user: owner_user) }
  let(:admin_sub) { create(:subscription, account: admin_user.account, user: admin_user) }
  let(:plan) { build(:plan_with_fake_id) }
  let(:product) { build(:product_with_fake_id) }

  before(:each) do
    owner_sub
    admin_sub
  end

  context 'when is an admin' do
    subject { Ability.new(admin_user) }
    it 'has permssion to access only the related account objects' do
      expect(subject).to     be_able_to(:manage, admin_user.account)
      expect(subject).to     be_able_to(:manage, owner_user.account)
      expect(subject).to     be_able_to(:manage, member_user.account)
      expect(subject).to     be_able_to(:manage, owner_user)
      expect(subject).to     be_able_to(:manage, member_user)
      expect(subject).to     be_able_to(:manage, admin_user.roles.first)
      expect(subject).to     be_able_to(:manage, owner_user.roles.first)
      expect(subject).to     be_able_to(:manage, admin_user.subscriptions.first)
      expect(subject).to     be_able_to(:manage, owner_user.subscriptions.first)
      expect(subject).to     be_able_to(:manage, plan)
      expect(subject).to     be_able_to(:manage, product)
    end
  end

  context 'when is a owner' do
    subject { Ability.new(owner_user) }
    it 'has permssion to access only the related account objects' do
      expect(subject).to     be_able_to(:manage, owner_user.account)
      expect(subject).to     be_able_to(:manage, owner_user)
      expect(subject).to     be_able_to(:manage, member_user)
      expect(subject).to     be_able_to(:manage, owner_user.roles.first)
      expect(subject).to     be_able_to(:manage, member_user.roles.first)
      expect(subject).to     be_able_to(:manage, owner_user.subscriptions.first)
      expect(subject).to     be_able_to(:read,   plan)
      expect(subject).not_to be_able_to(:read,   admin_user.account)
      expect(subject).not_to be_able_to(:read,   admin_user)
      expect(subject).not_to be_able_to(:read,   admin_user.roles.first)
      expect(subject).not_to be_able_to(:read,   admin_user.subscriptions.first)
      expect(subject).not_to be_able_to(:read,   product)
      expect(subject).not_to be_able_to(:manage, plan)
    end
  end

  context 'when is a member' do
    subject { Ability.new(member_user) }
    it 'has permission to read only the related account objects' do
      expect(subject).to     be_able_to(:manage, member_user)
      expect(subject).to     be_able_to(:read,   owner_user.account)
      expect(subject).to     be_able_to(:read,   owner_user)
      expect(subject).to     be_able_to(:read,   member_user.roles.first)
      expect(subject).not_to be_able_to(:manage, owner_user)
      expect(subject).not_to be_able_to(:manage, member_user.account)
      expect(subject).not_to be_able_to(:manage, member_user.roles.first)
      expect(subject).not_to be_able_to(:read,   plan)
      expect(subject).not_to be_able_to(:read,   admin_user.account)
      expect(subject).not_to be_able_to(:read,   admin_user)
      expect(subject).not_to be_able_to(:read,   admin_user.subscriptions.first)
      expect(subject).not_to be_able_to(:read,   product)
    end
  end
end
