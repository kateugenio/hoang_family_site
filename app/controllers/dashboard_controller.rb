class DashboardController < ApplicationController
  # GET /
  def index
    @user = current_user
    @photo_album = PhotoAlbum.find_by(is_admin: true, admin_type: 'home_page_carousel')
  end

  # GET dashboard/skip_profile_photo_upload
  def skip_profile_photo_upload
    session[:skipped_profile_photo_upload] = true
  end
end
