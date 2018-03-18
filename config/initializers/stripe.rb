Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
Stripe.logger = Rails.logger
Stripe.log_level = Stripe::LEVEL_INFO if Rails.env.development?
