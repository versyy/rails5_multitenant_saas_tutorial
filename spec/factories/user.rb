FactoryBot.define do
  factory :user, class: User do
    first_name 'FirstName'
    last_name 'LastName'
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Date.today }
    account

    trait :as_admin do
      after(:create) do |user|
        user.add_role :admin
      end
    end

    trait :as_owner do
      after(:create) do |user|
        user.add_role :owner
      end
    end
  end

  trait :as_admin do
    after(:create) { |user| user.add_role(:admin) }
  end

  trait :as_owner do
    after(:create) { |user| user.add_role(:owner, user.account) }
  end
end
