FactoryBot.define do
  factory :subscription_item do
    subscription nil
    plan nil
    stripe_id "MyString"
    quantity 1
  end
end
