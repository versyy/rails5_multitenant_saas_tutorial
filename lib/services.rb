require 'services/error'

module Services
  class << self
    private

    def logger
      Rails.logger
    end
  end
end
