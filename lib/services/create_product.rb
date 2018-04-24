require 'services/base_service'
require 'services/error'

module Services
  class CreateProduct < BaseService
    Response = Struct.new(:success?, :product, :stripe_product, :errors)

    def initialize(product_class:, stripe_create_product_svc:, logger:)
      @product_class = product_class
      @stripe_create_product_svc = stripe_create_product_svc
      super(logger: logger)
    end

    # Product define the overall service offering and associated features;
    #
    # product_params = any viable params for Product.create(params)
    #
    # returns: Response object
    def call(product_params:)
      local_product, stripe_product = nil

      @product_class.transaction do
        local_product = @product_class.create!(product_params)
        stripe_product = create_stripe_product(local_product)
        local_product.update!(update_product_params(stripe_product))
      end
      create_response(true, local_product, stripe_product)
    rescue StandardError => e
      log_error(CreateProductError.new(e))
      create_response(false)
    end

    private

    def update_product_params(stripe_product)
      {
        stripe_id:            stripe_product.id,
        name:                 stripe_product.name,
        stripe_type:          stripe_product.type,
        statement_descriptor: stripe_product.statement_descriptor,
        unit_label:           stripe_product.unit_label
      }.compact
    end

    def create_stripe_product(local_product)
      result = @stripe_create_product_svc.call(product: local_product)
      log_error(result.errors.first) unless result.errors.empty?
      raise CreateProductError, "product to stripe: #{plan.attributes}" unless result.success?
      result.record
    end

    def create_response(success, plan = nil, stripe_plan = nil)
      Response.new(success, plan, stripe_plan, errors)
    end
  end
end
