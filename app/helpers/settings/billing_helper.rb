module Settings
  module BillingHelper
    def form_with_subscription_params(subscription:)
      hash = { model: subscription }

      if subscription.id.nil?
        hash[:url]    = settings_subscriptions_path
        hash[:method] = :post
      else
        hash[:url]    = settings_subscription_path(subscription)
        hash[:method] = :put
      end

      hash
    end
  end
end
