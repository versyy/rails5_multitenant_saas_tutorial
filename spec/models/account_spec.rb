require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:valid_websites) do
    ['http://www.google.com', 'https://google.co.uk', 'http://www.foo_bar.com']
  end

  it 'is valid with valid attributes' do
    valid_websites.each do |website|
      expect(build(:account, website: website)).to be_valid
    end
  end

  it 'is invalid with invalid website' do
    expect(build(:account, website: 'invalid-domain')).to be_invalid
  end

  it 'is invalid with duplicate website' do
    account = create(:account)
    expect(build(:account, website: account.website)).to be_invalid
  end

  it 'is invalid with missing company' do
    expect(build(:account, company: nil)).to be_invalid
  end

  it 'has a subscription association' do
    expect(subject.subscriptions.count).to eq(0)
    expect(subject.subscriptions.respond_to?(:build)).to be
  end

  it 'has a plan association' do
    expect(subject.plans.count).to eq(0)
    expect(subject.plans.respond_to?(:build)).to be
  end
end
