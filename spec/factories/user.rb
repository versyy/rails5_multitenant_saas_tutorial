FactoryBot.define do
  factory :user, class: User do
    first_name 'FirstName'
    last_name 'LastName'
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Date.today }
    account
  end
end
