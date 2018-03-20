FactoryBot.define do
  factory :subscription do
    user
    account                 { user.account }
    status                  'MyString'
    started_at              '2018-01-01 11:11:11'
    stripe_id               'MyString'
    idempotency_key         { SecureRandom.uuid }

    trait :with_fake_id do
      id { SecureRandom.uuid }
    end

    factory :subscription_with_fake_id, traits: [:with_fake_id]
  end
end
