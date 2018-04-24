class WelcomeController < ApplicationController
  include WelcomeHelper
  skip_before_action :set_current_account
  skip_before_action :authenticate_user!
  skip_authorization_check

  def index
    redirect_to default_dashboard unless current_user.nil?
    @plans = Plan.displayable
  end
end
