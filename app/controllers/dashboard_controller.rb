class DashboardController < ApplicationController
  # GET /
  def index
    @user = current_user
    return unless @user.sign_in_count == 1 && !@user.admin?

    session[:new_user_modal] = true
  end
end
