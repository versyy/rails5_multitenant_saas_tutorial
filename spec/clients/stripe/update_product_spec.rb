require 'lib_helper'
require 'clients/stripe/update_product'

RSpec.describe Clients::Stripe::UpdateProduct do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:params) { { name: 'h', stripe_id: 'p_1', unit_label: 'lbl', statement_descriptor: 'dsc' } }
  let(:product) { double(:product, params) }
  let(:stripe_product) { double(:stripe_product, id: 'p_1', save: true) }
  let(:stripe_product_class) { class_double('Stripe::Product', retrieve: stripe_product) }
  let(:ctxt) { described_class.new(stripe_product_class: stripe_product_class, logger: logger) }

  subject { ctxt }

  before(:each) do
    allow(stripe_product).to receive(:name=)
    allow(stripe_product).to receive(:unit_label=)
    allow(stripe_product).to receive(:statement_descriptor=)
  end

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(product: product) }

    it { is_expected.to be_success }

    it 'calls underlying API as expected' do
      expect(stripe_product_class).to receive(:retrieve)
      expect(stripe_product).to receive(:save)
      subject
    end

    it 'returns the expected stripe_product' do
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
