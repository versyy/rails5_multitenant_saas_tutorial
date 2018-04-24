require 'spec_helper'
require 'clients/send_with_us/mock_client'

RSpec.describe Clients::SendWithUs::MockClient do
  let(:client) { double(:client, send_email: response) }
  let(:response) { double(:response) }

  describe '#deliver_msg' do
    subject { described_class.new.deliver_msg(template_id: 'id', to: 'val') }

    it 'returns Response object' do
      expect(subject).to be_a(Struct)
    end

    it 'returns Response with code 200' do
      expect(subject.code).to eq('200')
    end

    it 'returns Response with message OK' do
      expect(subject.message).to eq('OK')
    end
  end
end
