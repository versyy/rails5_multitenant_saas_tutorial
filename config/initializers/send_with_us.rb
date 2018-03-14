SendWithUs::Api.configure do |config|
  config.api_key = ENV.fetch('API_KEY_SENDWITHUS')
  config.debug = !Rails.env.production?
end
