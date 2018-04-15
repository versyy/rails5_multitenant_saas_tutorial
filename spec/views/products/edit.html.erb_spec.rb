require 'rails_helper'

RSpec.describe 'products/edit', type: :view do
  let(:product) { create(:product) }
  before(:each) { assign(:product, product) }

  it 'renders edit product form' do
    render

    assert_select 'form[action=?][method=?]', product_path(product), 'post' do
      assert_select 'input[type="hidden"][name="_method"][value="patch"]'
      assert_select 'input[name=?]', 'product[name]'
      assert_select 'input[name=?]', 'product[description]'
      assert_select 'input[name=?]', 'product[unit_label]'
      assert_select 'input[name=?]', 'product[statement_descriptor]'
    end
  end
end
