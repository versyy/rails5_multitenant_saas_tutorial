FactoryBot.define do
  factory :account, class: Account do
    company 'Company'
    website { Faker::Internet.url(Faker::Internet.domain_name, '') }
  end
end
