FactoryBot.define do
  factory :plan, class: Plan do
    name              'startup'
    stripe_id         'startup'
    amount            1000
    currency          'usd'
    interval          'month'
    interval_count    1
    trial_period_days 14
    active            true
    displayable       true
    integrations      false
    users             1
  end
end
