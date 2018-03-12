# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    skip_before_action :authenticate_user!, only: [:edit, :update]
    skip_before_action :set_current_account, only: [:edit, :update]
  end
end
