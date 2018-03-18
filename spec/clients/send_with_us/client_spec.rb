require 'lib_helper'
require 'send_with_us'

RSpec.describe Clients::SendWithUs::Client do
  let(:client) { double(:client, send_email: response) }
  let(:response) { double(:response) }
  let(:payload) { { link: 'https://example.com/link' } }
  before(:each) { allow(::SendWithUs::Api).to receive(:new).and_return(client) }

  describe '#deliver_msg' do
    subject { described_class.new.deliver_msg(template_id: 'id', to: 'val', payload: payload) }

    it 'calls SendWithUs::Api to recieve #new method' do
      expect(::SendWithUs::Api).to receive(:new)
      subject
    end

    it 'expect instance of SendWithUs::Api to receive #deliver_msg' do
      expect(client).to receive(:send_email).with('id', 'val', data: payload)
      subject
    end

    context 'when SendWithUs::Api throws an error' do
      before(:each) { allow(::SendWithUs::Api).to receive(:new).and_raise(::SendWithUs::Error.new) }

      it 'expect instance of SendWithUs::Api to receive #deliver_msg' do
        expect { subject }.to raise_error described_class::SendWithUsError
      end
    end
  end
end
