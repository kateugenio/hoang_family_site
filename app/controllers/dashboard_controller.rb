class DashboardController < ApplicationController
  # GET /
  def index
    @user = current_user
    @photo_album = PhotoAlbum.find_by(is_admin: true)
    return unless @user.sign_in_count == 1 && !@user.admin?

    session[:new_user_modal] = true
  end
end
