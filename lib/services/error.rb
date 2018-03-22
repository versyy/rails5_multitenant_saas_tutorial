module Services
  class Error < StandardError; end
  class CreatePlanError < Error; end
  class CreateProductError < Error; end
  class RegisterAccountError < Error; end
end
