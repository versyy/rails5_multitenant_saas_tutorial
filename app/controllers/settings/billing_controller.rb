module Settings
  class BillingController < ApplicationController
    include Settings::BillingHelper
    authorize_resource :plan

    def index
      @plans = Plan.where(active: true, displayable: true)
      @current_subscription = current_user.subscriptions.find_by(status: 'active') ||
                              current_user.subscriptions.build
      @new_subscription_item = @current_subscription.subscription_items.build
      @valid_payment_source = verify_payment_source(current_user)
      @stipe_key = ENV.fetch('STRIPE_PUBLISHED_KEY')
    end

    private

    def verify_payment_source(user)
      Services.verify_payment_source.call(user: user).success?
    end
  end
end
