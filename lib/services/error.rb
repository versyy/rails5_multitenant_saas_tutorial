module Services
  class Error < StandardError; end
  class CancelSubscriptionError < Error; end
  class CreatePaymentSourceError < Error; end
  class CreatePlanError < Error; end
  class CreateProductError < Error; end
  class CreateSubscriptionError < Error; end
  class InvalidPaymentTokenError < Error; end
  class RegisterAccountError < Error; end
  class UpdateSubscriptionError < Error; end
  class UpdateProductError < Error; end
  class VerifyPaymentTokenError < Error; end
end
