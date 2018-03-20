FactoryBot.define do
  factory :plan do
    product
    name              'startup-monthly'
    stripe_id         'startup-monthly-001'
    amount            1000
    currency          'usd'
    interval          'month'
    interval_count    1
    trial_period_days 7
    active            true
    displayable       true

    trait :with_fake_id do
      id { SecureRandom.uuid }
    end

    factory :plan_with_fake_id, traits: [:with_fake_id]
  end
end
