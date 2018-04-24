require 'rails_helper'

RSpec.describe Settings::BillingHelper, type: :helper do
  describe '#form_with_subscription_params' do
    let(:sub) { build(:subscription_with_fake_id) }
    subject { helper.form_with_subscription_params(subscription: sub) }

    context 'when the subscription already exists' do
      it 'creates form params for a PUT/PATCH' do
        expect(subject).to include(
          model:  sub,
          url:     settings_subscription_path(id: sub.id),
          method: :put
        )
      end
    end

    context 'when the subscription does not exist yet' do
      let(:sub) { build(:subscription) }
      it 'creates form params for a POST' do
        expect(subject).to include(
          model:  sub,
          url:     settings_subscriptions_path,
          method: :post
        )
      end
    end
  end
end
