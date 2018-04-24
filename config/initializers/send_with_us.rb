SendWithUs::Api.configure do |config|
  config.api_key = ENV.fetch('SENDWITHUS_API_KEY')
  config.debug = !Rails.env.production?
end
