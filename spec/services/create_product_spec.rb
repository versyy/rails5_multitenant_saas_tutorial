require 'rails_helper'

RSpec.describe Services::CreateProduct do
  let(:logger) { double(:logger, debug: true, fatal: true) }
  let(:attribs) { attributes_for(:product) }
  let(:product) { instance_double('Product', update!: true) }
  let(:product_class) { class_double('Product', create!: product) }
  let(:stripe_create_product_svc) do
    instance_double('Clients::Stripe::CreateProduct', call: result)
  end
  let(:result) { double(:result, success?: true, record: stripe_product, errors: errors) }
  let(:stripe_product_params) do
    { id: 'spr_1', name: 'w', type: 'service', statement_descriptor: 'sd', unit_label: 'ul' }
  end
  let(:stripe_product) { double(:stripe_product, stripe_product_params) }
  let(:errors) { [] }
  let(:ctxt) do
    described_class.new(
      product_class: product_class,
      stripe_create_product_svc: stripe_create_product_svc,
      logger: logger
    )
  end
  subject { ctxt }

  it { is_expected.to be }

  describe '#call' do
    subject { ctxt.call(product_params: attribs) }

    before(:each) { allow(product_class).to receive(:transaction).and_yield }

    it { is_expected.to be_success }

    it 'returns the expected product' do
      expect(subject.product).to eq(product)
    end

    it 'returns the expected stripe_product' do
      expect(subject.stripe_product).to be(stripe_product)
    end

    context 'when an error occurs' do
      before(:each) do
        allow(product_class).to receive(:create!).and_raise(StandardError.new('message'))
      end
      it { is_expected.not_to be_success }

      it 'contains a CreateProductError' do
        expect(subject.errors.first).to be_a(Services::CreateProductError)
        expect(subject.errors.first.message).to eq('message')
      end
    end
  end
end
