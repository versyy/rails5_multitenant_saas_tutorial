require 'rails_helper'
require 'services/update_product'

RSpec.describe Services::UpdateProduct do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:product_class) { class_double('Product', find: product) }
  let(:product) { instance_double('Product', id: '1', update!: true, reload: true) }
  let(:product_params) { { name: 'h', unit_label: 'lbl', statement_descriptor: 'dsc' } }
  let(:stripe_update_product_svc) do
    instance_double('Services::Stripe::UpdateProduct', call: result)
  end
  let(:result) { double(:result, success?: true, record: stripe_product) }
  let(:stripe_product) { double(:stripe_product, id: '1') }
  let(:ctxt) do
    described_class.new(
      product_class: product_class,
      stripe_update_product_svc: stripe_update_product_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    before(:each) { allow(product).to receive(:transaction).and_yield }
    subject { ctxt.call(product_id: product.id, params: product_params) }

    it { is_expected.to be_success }

    it 'returns the expected product' do
      expect(subject.product).to be(product)
    end

    it 'updates the product with the provided params' do
      expect(product).to receive(:update!).with(product_params)
      subject
    end

    it 'sends the product to the Stripe::UpdateProduct' do
      expect(stripe_update_product_svc).to receive(:call).with(product: product)
      subject
    end

    it 'returns the expected stripe_product' do
      expect(subject.stripe_product).to be(stripe_product)
    end

    context 'when an unknown error occurs' do
      before(:each) do
        allow(product_class).to receive(:find).and_raise(StandardError.new('message'))
      end
      it { is_expected.not_to be_success }

      it 'contains a UpdateProductError' do
        expect(subject.errors.first).to be_a(Services::UpdateProductError)
        expect(subject.errors.first.message).to eq('message')
      end
    end
  end
end
