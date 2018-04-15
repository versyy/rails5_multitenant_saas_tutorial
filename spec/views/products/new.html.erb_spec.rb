require 'rails_helper'

RSpec.describe 'products/new', type: :view do
  before(:each) { assign(:product, build(:product)) }

  it 'renders new product form' do
    render

    assert_select 'form[action=?][method=?]', products_path, 'post' do
      assert_select 'input[name=?]', 'product[name]'
      assert_select 'input[name=?]', 'product[description]'
      assert_select 'input[name=?]', 'product[unit_label]'
      assert_select 'input[name=?]', 'product[statement_descriptor]'
    end
  end
end
