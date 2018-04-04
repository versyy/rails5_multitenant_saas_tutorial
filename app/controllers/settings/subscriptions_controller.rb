module Settings
  class SubscriptionsController < ApplicationController
    authorize_resource

    def index
      @subscriptions = current_user.account.subscriptions
    end

    def show
      @subscription = Subscription.find(params[:id])
    end

    def create
      create_payment_source(payment_token_param) unless payment_token_param.nil?
      result = create_subscription(sub_params)

      if result.success?
        respond_with_success(result.subscription, 'Subscription was successfully created.')
      else
        respond_with_bad_request
      end
    end

    def update
      create_payment_source(payment_token_param) unless payment_token_param.nil?
      result = update_subscription(params[:id], sub_params)

      if result.success?
        respond_with_success(result.subscription, 'Subscription was successfully updated.')
      else
        respond_with_bad_request
      end
    end

    def destroy
      result = cancel_subscription(params[:id])

      if result.success?
        respond_to do |format|
          format.html { redirect_to settings_billing_index_path }
          format.json { head :ok }
        end
      else
        respond_with_bad_request
      end
    end

    private

    def respond_with_bad_request
      respond_to do |format|
        format.html { head :bad_request }
        format.json { head :bad_request }
      end
    end

    def respond_with_success(subscription, notice)
      respond_to do |format|
        format.html { redirect_to settings_billing_index_path, notice: notice }
        format.json { render json: subscription.to_json }
      end
    end

    def cancel_subscription(subscription_id)
      Services.cancel_subscription.call(subscription_id: subscription_id)
    end

    def create_payment_source(payment_token)
      Services.create_payment_source.call(user: current_user, payment_token: payment_token)
    end

    def create_subscription(arr_plan_params)
      Services.create_subscription.call(user: current_user, params: arr_plan_params)
    end

    def update_subscription(subscription_id, sub_params)
      Services.update_subscription.call(subscription_id: subscription_id, params: sub_params)
    end

    def sub_params
      params.require(:subscription).permit(subscription_items: [:plan_id, :quantity])
    end

    def payment_token_param
      params.require(:stripeToken) if params.include?(:stripeToken)
    end
  end
end
