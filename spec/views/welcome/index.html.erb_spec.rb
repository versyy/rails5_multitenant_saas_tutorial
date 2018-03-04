require 'rails_helper'

RSpec.describe 'welcome/index.html.erb', type: :view do
  it 'renders links to key models' do
    render
    assert_select 'div>h1', text: 'Welcome#index', count: 1
  end
end
