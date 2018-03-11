class WelcomeController < ApplicationController
  skip_before_action :set_current_account

  def index; end
end
