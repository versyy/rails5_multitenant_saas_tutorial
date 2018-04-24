require 'services/base_service'
require 'services/error'

module Services
  class UpdateProduct < BaseService
    Response = Struct.new(:success?, :product, :stripe_product, :errors)

    def initialize(product_class:, stripe_update_product_svc:, logger:)
      @product_class             = product_class
      @stripe_update_product_svc = stripe_update_product_svc
      super(logger: logger)
    end

    # Updates the product locally and with Stripe
    #
    # product_id:        String, # <= the ID of the subscription to be updated
    # params:           {} # <= a valid hash for Product.update!( params )
    #
    # returns:          Response object
    def call(product_id:, params:)
      process_update(product_id, params)
    rescue StandardError => e
      log_error(UpdateProductError.new(e))
      create_response(nil, nil)
    end

    private

    def process_update(product_id, params)
      product = @product_class.find(product_id)
      stripe_product = nil

      product.transaction do
        product.update!(params)
        stripe_product = update_stripe_product(product)
      end

      self.success = true
      create_response(product, stripe_product)
    end

    def update_stripe_product(product)
      result = @stripe_update_product_svc.call(product: product)
      raise UpdateProductError, result.errors.map(&:message) unless result.success?
      result.record
    end

    def create_response(product, stripe_product)
      Response.new(success, product, stripe_product, errors)
    end
  end
end
