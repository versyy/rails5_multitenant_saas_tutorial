require 'rails_helper'

RSpec.describe 'products/index', type: :view do
  let(:product) { build(:product_with_fake_id, stripe_id: 'fake_id') }
  before(:each) { assign(:products, [product, product]) }

  it 'renders a list of products' do
    render
    assert_select 'tr>td', text: product.name, count: 2
    assert_select 'tr>td', text: product.stripe_id, count: 2
    assert_select 'tr>td', text: product.unit_label, count: 2
    assert_select 'tr>td', text: product.statement_descriptor, count: 2
  end
end
