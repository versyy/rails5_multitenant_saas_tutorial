Payola.configure do |config| # rubocop:disable Metrics/BlockLength
  config.secret_key = ENV.fetch('API_KEY_STRIPE_SECRET')
  config.publishable_key = ENV.fetch('API_KEY_STRIPE_PUBLISHED')

  config.default_currency = 'usd'

  # prevent more than one active subscription for a given user
  config.charge_verifier = lambda do |event|
    user = User.find_by(email: event.email)
    if event.is_a?(Payola::Subscription) && user.subscriptions.active.any?
      raise 'Error: This user already has an active subscription plan.'
    end
    event.owner = user
    event.save!
  end

  # send new subscription email
  config.subscribe('customer.subscription.created') do |event|
    CommunicatorMailer.new_subscription_plan(
      Payola::Subscription.find_by(stripe_id: event.data.object.id)
    )
  end

  config.subscribe('customer.subscription.updated') do |event|
    # if the subscription is updated
    subscription = Payola::Subscription.find_by(stripe_id: event.data.object.id)
    if event.as_json.dig('data', 'previous_attributes').key?('items')
      # send upgrade email
      previous_items = event.as_json.dig('data', 'previous_attributes', 'items', 'data').first
      old_amount = previous_items.dig('plan').fetch('amount')
      CommunicatorMailer.upgrade_subscription_plan(
        subscription.id,
        old_amount
      )
    else
      # Send cancel subscription email
      CommunicatorMailer.cancel_subscription_plan_email(subscription.id).deliver
    end
  end
end
