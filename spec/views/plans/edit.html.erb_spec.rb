require 'rails_helper'

RSpec.describe 'plans/edit', type: :view do
  # let(:plan) { build(:plan, :with_fake_id) }
  let(:plan) { create(:plan) }
  before(:each) { @plan = assign(:plan, plan) }

  it 'renders edit plan form' do
    render

    assert_select 'form[action=?][method=?]', plan_path(plan), 'post' do
      assert_select 'input[name=?]', 'plan[active]'
      assert_select 'input[name=?]', 'plan[displayable]'
    end
  end
end
