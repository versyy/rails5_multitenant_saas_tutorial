require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user, account: first_user.account) }
  let(:third_user) { create(:user) }

  context 'when is an admin' do
    subject(:ability) { Ability.new(first_user) }
    before(:each) { second_user }
    it 'has permssion to access only the related account objects' do
      first_user.add_role(:admin)
      expect(subject).to     be_able_to(:manage, first_user.account)
      expect(subject).to     be_able_to(:manage, second_user)
      expect(subject).to     be_able_to(:manage, first_user.roles.first)
      expect(subject).to     be_able_to(:manage, second_user.roles.first)
      expect(subject).to     be_able_to(:manage, third_user)
      expect(subject).to     be_able_to(:manage, third_user.account)
    end
  end

  context 'when is a owner' do
    subject(:ability) { Ability.new(first_user) }
    before(:each) { second_user }
    it 'has permssion to access only the related account objects' do
      expect(subject).to     be_able_to(:manage, first_user.account)
      expect(subject).to     be_able_to(:manage, second_user)
      expect(subject).to     be_able_to(:manage, first_user.roles.first)
      expect(subject).to     be_able_to(:manage, second_user.roles.first)
      expect(subject).not_to be_able_to(:read,   third_user)
      expect(subject).not_to be_able_to(:read,   third_user.account)
    end
  end

  context 'when is a member' do
    subject(:ability) { Ability.new(second_user) }
    it 'has permission to read only the related account objects' do
      expect(subject).to     be_able_to(:read,   second_user.account)
      expect(subject).to     be_able_to(:read,   first_user)
      expect(subject).to     be_able_to(:read,   second_user.roles.first)
      expect(subject).not_to be_able_to(:manage, second_user.account)
      expect(subject).not_to be_able_to(:manage, first_user)
      expect(subject).not_to be_able_to(:manage, second_user.roles.first)
      expect(subject).not_to be_able_to(:read,   third_user)
      expect(subject).not_to be_able_to(:read,   third_user.account)
    end
  end
end
