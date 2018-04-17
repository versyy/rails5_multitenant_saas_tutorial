class WelcomeController < ApplicationController
  skip_before_action :set_current_account
  skip_before_action :authenticate_user!

  def index; end
end
