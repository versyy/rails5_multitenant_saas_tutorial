require 'versyy/communicator'

Versyy::Communicator.configure do |c|
  c.use_mock = !Rails.env.production?
  c.verbose = Rails.env.development?
end
