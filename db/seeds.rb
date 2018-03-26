# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
Rails.configuration.logger = Logger.new(STDOUT)
Rails.configuration.log_level = :debug

# create free product and monthly plan
product = nil
Utils.say_with_time 'Creating Free Product' do
  result = Services.create_product.call(
    product_params: {
      name: 'Free',
      description: 'Great for companies just getting started',
      unit_label: 'user',
      statement_descriptor: 'RMST Free'
    }
  )
  product = result.product
  "Created Product with ID: #{product.id}" if result.success?
end

# create default plan
Utils.say_with_time 'Creating Free Yearly Plan' do
  result = Services.create_plan.call(
    plan_params: { name: 'Free Yearly', product_id: product.id, amount: 0, interval: 'year' }
  )

  "Created Plan with ID: #{result.plan.id}" if result.success?
end


# create startup product and monthly plan
product = nil
Utils.say_with_time 'Creating Startup Product' do
  result = Services.create_product.call(
    product_params: {
      name: 'Startup',
      description: 'Great for companies iterating to find Product Market Fit',
      unit_label: 'user',
      statement_descriptor: 'RMST Startup'
    }
  )

  product = result.product
  "Created Product with ID: #{product.id}" if result.success?
end

# create default plan
Utils.say_with_time 'Creating Startup Monthly' do
  result = Services.create_plan.call(
    plan_params: { name: 'Startup Monthly', product_id: product.id, amount: 1000 }
  )

  "Created Plan with ID: #{result.plan.id}" if result.success?
end

