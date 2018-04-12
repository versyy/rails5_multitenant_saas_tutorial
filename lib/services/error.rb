module Services
  class Error < StandardError; end
  class CreateProductError < Error; end
  class RegisterAccountError < Error; end
end
