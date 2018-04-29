require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#default_dashboard' do
    subject { helper.default_dashboard }
    let(:user) { create(:user) }

    before(:each) { sign_in user }
    after(:each) { ActsAsTenant.current_tenant = false }

    it { is_expected.to eq(dashboard_path) }
  end

  describe '#flash_class' do
    {
      notice: 'info', success: 'success', alert: 'warning', error: 'danger', other: 'other'
    }.each do |key, value|
      it "returns a class level for #{key}" do
        expect(helper.flash_class(key)).to eq("alert-#{value}")
      end
    end
  end

  describe '#layout_name' do
    subject { helper.layout_name }

    context 'when user logged in' do
      let(:user) { create(:user) }
      before(:each) { sign_in user }
      after(:each) { ActsAsTenant.current_tenant = false }

      it { is_expected.to eq('authenticated') }
    end

    context 'when no user logged in' do
      it { is_expected.to eq('unauthenticated') }
    end
  end
end
