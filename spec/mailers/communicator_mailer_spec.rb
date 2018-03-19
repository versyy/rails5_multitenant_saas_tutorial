require 'rails_helper'

RSpec.describe CommunicatorMailer, type: :mailer do
  let(:user) { build(:user) }
  let(:token) { 'token' }
  let(:ctxt) { described_class.new }
  let(:subscription) { double(:subscription, attributes: {}, user: user) }

  describe '#confirmation_instructions' do
    subject { ctxt.confirmation_instructions(user, token) }

    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end

    it 'sends a valid accept_invitation_link' do
      body = JSON.parse(subject.body)
      link = body['payload']['confirmation_link']
      expect(link).to match(/\/users\/confirmation\?confirmation_token=token/)
    end
  end

  describe '#reset_password_instructions' do
    subject { ctxt.reset_password_instructions(user, token) }

    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end

    it 'sends a valid accept_invitation_link' do
      body = JSON.parse(subject.body)
      link = body['payload']['reset_password_link']
      expect(link).to match(/\/users\/password\/edit\?reset_password_token=token/)
    end
  end

  # Uncomment below if you add :Unlockable module for devise
  #
  # describe '#unlock_instructions' do
  #  subject { ctxt.unlock_instructions(user, token) }
  #  it 'delivers to SendWithUs' do
  #    expect(subject.code).to eq('200')
  #  end
  # end

  describe '#email_changed' do
    subject { ctxt.email_changed(user) }

    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end
  end

  describe '#password_change' do
    subject { ctxt.password_change(user) }

    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end
  end

  describe '#invitation_instructions' do
    subject { ctxt.invitation_instructions(user, token) }
    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end

    it 'sends a valid accept_invitation_link' do
      body = JSON.parse(subject.body)
      link = body['payload']['accept_invitation_link']
      expect(link).to match(/\/users\/invitation\/accept\?invitation_token=token/)
    end
  end

  describe '#new_subscription_plan' do
    subject { ctxt.new_subscription_plan(subscription) }
    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end

    it 'includes user values' do
      body = JSON.parse(subject.body)
      expect(body['payload']['user']).to include(user.safe_attributes.stringify_keys!)
    end
  end

  describe '#cancel_subscription_plan' do
    subject { ctxt.cancel_subscription_plan(subscription) }
    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end

    it 'includes user values' do
      body = JSON.parse(subject.body)
      expect(body['payload']['user']).to include(user.safe_attributes.stringify_keys!)
    end
  end

  describe '#update_subscription_plan' do
    let(:old_amount) { 20_000 }
    subject { ctxt.upgrade_subscription_plan(subscription, old_amount) }
    it 'returns with a 200 code' do
      expect(subject.code).to eq('200')
    end

    it 'includes user values' do
      body = JSON.parse(subject.body)
      expect(body['payload']['user']).to include(user.safe_attributes.stringify_keys!)
    end

    it 'includes old_amount value' do
      body = JSON.parse(subject.body)
      expect(body['payload']['old_amount']).to eq(old_amount)
    end
  end
end
