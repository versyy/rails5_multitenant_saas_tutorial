class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  set_current_tenant_through_filter
  before_action :set_current_account

  def set_current_account
    set_current_tenant(current_account)
  end

  def current_account
    @current_account ||= Account.find(session[:account_id])
  end
end
