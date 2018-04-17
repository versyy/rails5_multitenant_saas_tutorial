require 'clients/send_with_us'

Clients::SendWithUs.configure do |c|
  c.use_mock = !Rails.env.production?
  c.verbose = Rails.env.development?
end
