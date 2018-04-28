class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  set_current_tenant_through_filter
  before_action :authenticate_user!
  before_action :set_current_account
  check_authorization

  def set_current_account
    set_current_tenant(current_account)
  end

  def current_account
    @current_account ||= current_user.account
  end
end
