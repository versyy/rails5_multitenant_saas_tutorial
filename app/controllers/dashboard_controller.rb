class DashboardController < ApplicationController
  # GET /dashboard
  def index
    authorize! :index, current_user
  end
end
