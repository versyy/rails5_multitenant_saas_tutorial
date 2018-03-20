FactoryBot.define do
  factory :plan do
    name "MyString"
    stripe_id "MyString"
    amount 1
    currency "MyString"
    interval "MyString"
    interval_count 1
    trial_period_days 1
    active false
    displayable false
    integrations false
    users 1
  end
end
