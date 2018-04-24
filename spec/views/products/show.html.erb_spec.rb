require 'rails_helper'

RSpec.describe 'products/show', type: :view do
  let(:product) { build(:product_with_fake_id) }
  before(:each) { assign(:product, product) }

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/startup/)
    expect(rendered).to match(/Great for/)
    expect(rendered).to match(/user/)
    expect(rendered).to match(/RMST App/)
  end
end
