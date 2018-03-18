require 'rails_helper'

RSpec.describe CommunicatorMailer, type: :mailer do
  let(:user) { build(:user) }
  let(:token) { 'token' }
  let(:ctxt) { described_class.new }

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
end
