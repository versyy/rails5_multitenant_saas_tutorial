Rails.logger = Logger.new(STDOUT)
Rails.logger.level = 0
Stripe.logger = Rails.logger
Stripe.log_level = Stripe::LEVEL_DEBUG

# shared password
password = 'test1234'

# create admin
email = 'admin@example.org'
Utils.say_with_time "Create Admin: #{email} with Password: #{password}" do
  account = Account.create(company: 'ExampleOrg', website: 'https://www.example.org')
  user = User.create(
    first_name: 'Admin', email: email, account: account, confirmed_at: Time.now,
    password: password, password_confirmation: password
  )
  user.add_role :admin
  User.where(email: email).count
end

# create owner
email = 'owner@acme.com'
account = Account.create(company: 'Acme', website: 'https://www.acme.com')
Utils.say_with_time "Create Owner: #{email} with Password: #{password}" do
  user = User.create(
    first_name: 'owner', email: email, account: account, confirmed_at: Time.now,
    password: password, password_confirmation: password
  )
  user.add_role :owner
  User.where(email: email).count
end

# create user
email = 'member@acme.com'
Utils.say_with_time "Create User: #{email} with Password: #{password}" do
  user = User.create(
    first_name: 'member', email: email, account: account, confirmed_at: Time.now,
    password: password, password_confirmation: password
  )
  user.add_role :member
  User.where(email: email).count
end

####  CREATE SUBSCRIPTION FOR ACME ACCOUNT ####
user = User.where(email: 'owner@acme.com').first

# create stripe payment source
Utils.say_with_time "Create Stripe Payment Source for #{user.email}" do
  result = Services.create_payment_source.call(user: user, payment_token: 'tok_visa')
  Utils.process_result(result) { 1 }
end

# verify the user has a payment source
Utils.say_with_time "Verifying Stripe Payment Source for #{user.email}" do
  result = Services.verify_payment_source.call(user: user)
  Utils.say "A Chargeable Payment Source has #{ 'NOT ' unless result.success? }been found"
end

# create subscription
Utils.say_with_time "Create Subscription for #{user.email}" do
  sub_items_params = [{ plan_id: Plan.where(amount: 1000).first.id, quantity: 1 }]
  sub_params = { subscription_items: sub_items_params}
  result = Services.create_subscription.call(user: user, params: sub_items_params)
  Utils.process_result(result) { 1 }
end

####  END ACME ACCOUNT ####

####  CREATE SUBSCRIPTION FOR EXAMPLE ACCOUNT ####

user = User.find_by_email('admin@example.org')
# create stripe payment source
Utils.say_with_time "Create Stripe Payment Source for #{user.email}" do
  result = Services.create_payment_source.call(user: user, payment_token: 'tok_visa')
  Utils.process_result(result) { 1 }
end

# create subscription
Utils.say_with_time "Create Subscription for #{user.email}" do
  sub_items_params = [{ plan_id: Plan.where(amount: 0).first.id, quantity: 1 }]
  result = Services.create_subscription.call(user: user, params: sub_items_params)
  Utils.process_result(result) { 1 }
end

# cancel subscription
Utils.say_with_time "Cancel Subscription for #{user.email}" do
  sub = user.subscriptions.first
  result = Services.cancel_subscription.call(subscription_id: sub.id)
  Utils.process_result(result) { 1 }
end

#### END EXAMPLE ACCOUNT ####


#### BEGIN - UPDATE ACME ACCOUNT ####

user = User.where(email: 'owner@acme.com').first
# update the subscription
Utils.say_with_time "Update Subscription for #{user.email}" do
  sub_items_params = [{ plan_id: Plan.find_by_amount(0).id, quantity: 2 }]
  sub_params = { subscription_items: sub_items_params}
  sub = user.subscriptions.first
  result = Services.update_subscription.call(subscription_id: sub.id, params: sub_params)
  Utils.process_result(result) { 1 }
end

#### END - UPDATE ACME ACCOUNT ####
