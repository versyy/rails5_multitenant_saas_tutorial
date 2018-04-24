require 'services/base_service'
require 'services/error'

module Services
  class CreatePaymentSource < BaseService
    Response = Struct.new(:success?, :payment_source, :errors)

    def initialize(stripe_create_payment_source_svc:, stripe_find_or_create_customer_svc:, logger:)
      @stripe_find_or_create_customer_svc = stripe_find_or_create_customer_svc
      @stripe_create_payment_source_svc = stripe_create_payment_source_svc
      super(logger: logger)
    end

    # Create a payment source from a payment_token
    #
    # user:           current_user, # <= With whom the source will be stored
    # payment_token:  'tok_visa'
    #
    # return:         Response object
    def call(user:, payment_token:)
      user = create_customer(user) if user.stripe_id.nil?
      result = create_payment_source(user, payment_token)
      self.success = true
      create_response(result.record)
    rescue CreatePaymentSourceError => e
      log_error e
      create_response
    end

    private

    def create_customer(user)
      result = @stripe_find_or_create_customer_svc.call(user: user)
      raise CreatePaymentSourceError, 'Unable to find or create user' unless result.success?
      user.update!(stripe_id: result.record.id)
      user
    end

    def create_payment_source(user, token)
      result = @stripe_create_payment_source_svc.call(user: user, payment_token: token)
      raise CreatePaymentSourceError, 'Unable to create payment source' unless result.success?
      result
    end

    def create_response(payment_source = nil)
      Response.new(success, payment_source, errors)
    end
  end
end
