require 'rails_helper'
require 'clients/stripe/create_product'

RSpec.describe Clients::Stripe::CreateProduct do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:local_product) { create(:product_with_fake_id) }
  let(:stripe_product) { double(:stripe_plan) }
  let(:stripe_product_class) { class_double('Stripe:Product', create: stripe_product) }
  let(:ctxt) do
    described_class.new(stripe_product_class: stripe_product_class, logger: logger)
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(product: local_product) }

    it { is_expected.to be_success }

    it 'calls stripe_product_class#create' do
      expect(stripe_product_class).to receive(:create).with(hash_including(:name, :type))
      subject
    end

    it 'returns the expected objects' do
      expect(subject.record).to eq(stripe_product)
    end

    context 'When an error occurs' do
      let(:stripe_product_class) { nil }
      it { is_expected.not_to be_success }

      it 'has errors' do
        expect(subject.errors.count).to eq(1)
      end
    end
  end
end
