class ProductsController < ApplicationController
  skip_before_action :set_current_account
  before_action :set_product, only: [:show, :destroy, :edit]
  authorize_resource

  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/:id
  def show; end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/:id/edit
  def edit; end

  # POST /products
  def create
    result = Services.create_product.call(product_params: product_params)
    @product = result.product

    if result.success?
      respond_to_success(@product, notice: 'Product was successfully created')
    else
      respond_to_failure(:new)
    end
  end

  # PUT/PATCH /products/:id
  def update
    result = Services.update_product.call(product_id: params[:id], params: product_params)
    @product = result.product

    if result.success?
      respond_to_success(@product, notice: 'Product was successfully updated')
    else
      respond_to_failure(:edit)
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :statement_descriptor, :unit_label
    )
  end

  def respond_to_success(product, notice)
    respond_to do |format|
      format.html { redirect_to product, notice: notice }
      format.json { render json: product.to_json }
    end
  end

  def respond_to_failure(template)
    respond_to do |format|
      format.html { render template }
      format.json { head :bad_request }
    end
  end
end
