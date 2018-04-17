require 'services/base_service'
require 'services/error'

module Services
  class RegisterAccount < BaseService
    Response = Struct.new(:success?, :account, :errors)

    def initialize(account_class:, logger:)
      @account_class = account_class
      super(logger: logger)
    end

    # Creates the account and assigns it to the user during registration
    #
    # account_params: Any viable params for Account.create(params)
    # user:           current_user # <= whom the account is being created on behalf
    #
    # return:         Response object
    def call(account_params:, user:)
      account = create_account(account_params, user)
      self.success = true
      create_response(account)
    rescue StandardError => e
      log_error(RegisterAccountError.new(e))
      create_response(account)
    end

    private

    def create_account(account_params, user)
      account = @account_class.create!(account_params)
      @logger.debug "Created New Account #{account} for User #{user}"
      assign_account_to_user(account, user)
      account
    end

    def assign_account_to_user(account, user)
      user.update!(account_id: account.id)
      @logger.debug "Assigned #{user} to #{account}"
    end

    def create_response(account = nil)
      Response.new(success, account, errors)
    end
  end
end
