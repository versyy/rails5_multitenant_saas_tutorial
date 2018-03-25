require 'rails_helper'

RSpec.describe 'plans/new', type: :view do
  before(:each) do
    assign(:plan, Plan.new)
    assign(:products, [build(:product_with_fake_id)])
  end
  it 'renders new plan form' do
    render

    assert_select 'form[action=?][method=?]', plans_path, 'post' do
      assert_select 'select[name=?]', 'plan[product_id]'
      assert_select 'input[name=?]', 'plan[name]'
      assert_select 'input[name=?]', 'plan[amount]'
      assert_select 'input[name=?]', 'plan[interval]'
      assert_select 'input[name=?]', 'plan[interval_count]'
      assert_select 'input[name=?]', 'plan[trial_period_days]'
      assert_select 'input[name=?]', 'plan[active]'
      assert_select 'input[name=?]', 'plan[displayable]'
    end
  end
end
