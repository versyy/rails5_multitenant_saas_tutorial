FactoryBot.define do
  factory :subscription do
    account nil
    plan nil
    started_at "2018-03-21 05:34:54"
    status "MyString"
    stripe_id "MyString"
    idempotency_key ""
  end
end
