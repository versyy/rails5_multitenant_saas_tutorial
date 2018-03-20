FactoryBot.define do
  factory :plan do
    product nil
    name "MyString"
    stripe_id "MyString"
    amount 1
    currency "MyString"
    interval "MyString"
    interval_count 1
    trial_period_days 1
    active false
    displayable false
  end
end
