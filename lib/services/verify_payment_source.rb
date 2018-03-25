require 'services/base_service'
require 'services/error'

module Services
  class VerifyPaymentSource < BaseService
    Response = Struct.new(:success?, :errors)

    def initialize(stripe_find_or_create_customer_svc:, logger:)
      @stripe_find_or_create_customer_svc = stripe_find_or_create_customer_svc
      super(logger: logger)
    end

    # Verifies the user has a payment source and it is chargeable
    #
    # user:         current_user # <= typically;
    #
    # return:       Response object
    def call(user:)
      customer = find_or_create_stripe_customer(user)
      raise VerifyPaymentTokenError, "Customer not found #{user.stripe_id}" if customer.nil?
      raise InvalidPaymentTokenError, 'Card is Missing' unless valid_payment_source?(customer)

      self.success = true
      create_response
    rescue StandardError => e
      log_error(e.is_a?(Services::Error) ? e : VerifyPaymentTokenError.new(e))
      create_response
    end

    private

    def find_or_create_stripe_customer(user)
      result = @stripe_find_or_create_customer_svc.call(user: user)
      result.record
    end

    def valid_payment_source?(customer)
      @logger.debug("customer :#{customer.id}; default_source: #{customer.default_source}")
      !customer.default_source.nil?
    end

    def create_response
      Response.new(success, errors)
    end
  end
end
