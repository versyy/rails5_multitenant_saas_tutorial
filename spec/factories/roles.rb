FactoryBot.define do
  factory :role do
    name 'Member'

    trait :owner do
      name 'owner'
    end

    trait :member do
      name 'member'
    end

    trait :account do
      resource { build(:account) }
    end

    factory :role_owner,        traits: [:owner]
    factory :role_member,       traits: [:member]
    factory :role_with_account, traits: [:account]
  end
end
