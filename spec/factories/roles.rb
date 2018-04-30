FactoryBot.define do
  factory :role do
    name 'member'

    trait :owner do
      name 'owner'
    end

    trait :member do
      name 'member'
    end

    factory :role_owner,        traits: [:owner]
    factory :role_member,       traits: [:member]
  end
end
