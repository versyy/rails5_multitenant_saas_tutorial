require 'rails_helper'

RSpec.describe Services::RegisterAccount do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:attribs) { { company: 'company', website: 'website' } }
  let(:user) { double(:user, update!: true, add_role: true) }
  let(:account) { double(:account, id: 'id') }
  let(:account_class) { double('Account', create!: account) }
  let(:ctxt) { described_class.new(account_class: account_class, logger: logger) }
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(account_params: attribs, user: user) }

    it { is_expected.to be_success }

    it 'returns the expected plan' do
      expect(subject.account).to be(account)
    end

    it 'creates a new account' do
      expect(account_class).to receive(:create!)
      subject
    end

    it 'assigns account to user' do
      expect(user).to receive(:update!).with(account_id: account.id)
      subject
    end

    it 'adds :owner role to user for account' do
      expect(user).to receive(:add_role).with(:owner, account)
      subject
    end

    context 'when an error occurs' do
      before(:each) do
        allow(account_class).to receive(:create!).and_raise(StandardError.new('message'))
      end
      it { is_expected.not_to be_success }

      it 'contains a RegisterAccountError' do
        expect(subject.errors.first).to be_a(Services::RegisterAccountError)
        expect(subject.errors.first.message).to eq('message')
      end
    end
  end
end
