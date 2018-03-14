# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    skip_before_action :authenticate_user!, only: [:edit, :update]
    skip_before_action :set_current_account, only: [:edit, :update]
    skip_authorization_check only: [:edit, :update]

    # GET /resource/invitation/new
    def new
      authorize! :new, current_user
      super
    end

    # POST /resource/invitation
    def create
      authorize! :create, current_user
      super
    end

    # GET /resource/invitation/accept?invitation_token=abcdef
    # def edit
    #   super
    # end
    #
    # PUT /resource/invitation
    # def update
    #   super
    # end
    #
    # GET /resource/invitation/remove?invitation_token=abcdef
    # def destroy
    #   super
    # end
    #
    # private
    #
  end
end
