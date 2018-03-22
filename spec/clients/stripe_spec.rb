require 'lib_helper'

RSpec.describe Clients::Stripe do
  before(:each) { described_class.configure { |c| c.use_mock = use_mock } }

  after(:each) { described_class.configure { |c| c.use_mock = true } }

  describe '#client' do
    subject { described_class.client }
    context 'when use_mock is true' do
      let(:use_mock) { true }
      it { is_expected.to be_a(described_class::MockClient) }
    end

    context 'when use_mock is false' do
      let(:use_mock) { false }
      it { is_expected.to be_a(described_class::Client) }
    end
  end
end
