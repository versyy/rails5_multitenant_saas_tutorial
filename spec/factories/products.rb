FactoryBot.define do
  factory :product do
    name                  'startup'
    description           'Great for companies just getting started'
    statement_descriptor  'RMST App'
    unit_label            'user'

    trait :with_fake_id do
      id { SecureRandom.uuid }
    end

    factory :product_with_fake_id, traits: [:with_fake_id]
  end
end
