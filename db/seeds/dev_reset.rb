
Rails.logger = Logger.new(STDOUT)
Rails.logger.level = 0

Utils.say_with_time 'Delete Stripe Subscriptions' do
  counter = 0
  Subscription.where.not(status: 'cancelled').each do |sub|
    sub = ::Stripe::Subscription.retrieve(sub.stripe_id)
    sub.delete
    counter += 1
  end
  counter
end

# Drop AR data
Utils.say_with_time 'Delete SubscriptionItems' do
  result = SubscriptionItem.destroy_all
  result.count
end

Utils.say_with_time 'Delete Subscriptions' do
  result = Subscription.destroy_all
  result.count
end

Utils.say_with_time 'Delete Users' do
  result = User.destroy_all
  result.count
end

Utils.say_with_time 'Delete Accounts' do
  result = Account.destroy_all
  result.count
end
