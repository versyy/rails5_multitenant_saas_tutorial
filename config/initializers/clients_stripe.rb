require 'clients/stripe'

Clients::Stripe.configure do |c|
  c.use_mock = !Rails.env.production?
end
