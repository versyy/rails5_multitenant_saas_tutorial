require 'services/error'
require 'services/register_account'

module Services
  class << self
    def register_account
      RegisterAccount.new(
        account_class: ::Account,
        logger: logger
      )
    end

    private

    def logger
      Rails.logger
    end
  end
end
