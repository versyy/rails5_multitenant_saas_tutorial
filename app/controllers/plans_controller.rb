class PlansController < ApplicationController
  skip_before_action :set_current_account
  before_action :set_plan, only: [:show, :destroy, :edit, :update]
  authorize_resource

  # GET /plans
  def index
    @plans = Plan.all
  end

  # GET /plans/:id
  def show; end

  # GET /plans/new
  def new
    @plan = Plan.new
    @products = Product.all
  end

  # GET /plans/:id/edit
  def edit; end

  # POST /plans
  def create
    result = Services.create_plan.call(plan_params: create_params)
    @plan = result.plan

    respond_to do |format|
      if result.success?
        format.html { redirect_to @plan, notice: 'Plan was successfully created' }
      else
        format.html { render :new }
      end
    end
  end

  # PUT/PATCH /plans/:id
  def update
    respond_to do |format|
      if @plan.update(update_params)
        format.html { redirect_to @plan, notice: 'Plan was successfully updated' }
      else
        format.html { render :edit }
      end
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def create_params
    params.require(:plan).permit(
      :name, :product_id, :amount, :currency, :interval, :interval_count, :trial_period_days,
      :active, :displayable
    )
  end

  def update_params
    params.require(:plan).permit(:active, :displayable)
  end
end
