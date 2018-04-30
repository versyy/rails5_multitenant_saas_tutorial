FactoryBot.define do
  factory :subscription_item do
    subscription
    plan
    stripe_id     'MyString'
    quantity      1
  end
end
