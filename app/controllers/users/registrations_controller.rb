# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'empty', only: [:new, :create]

    skip_authorization_check only: [:new, :create]
    skip_before_action :set_current_account, only: [:new, :create]
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    def create
      ActiveRecord::Base.transaction do
        super do |user|
          result = register_account(account_params, user) if user.valid?
          @account = result&.account
          raise ActiveRecord::Rollback unless result&.success?
        end
      end
    end

    # GET /resource/edit
    def edit
      authorize! :edit, current_user
      super
    end

    # PUT /resource
    def update
      authorize! :manage, current_user
      super
    end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    def account_params
      params.require(:account).permit(:company, :website)
    end

    def register_account(attribs, user)
      Services.register_account.call(account_params: attribs, user: user)
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
