class UsersController < ApplicationController
  before_action :verify_allowed_render_tabs, only: [:update_settings, :update_password]
  before_action :verify_user_is_admin, only: [:admin_photo_album, :create_admin_photo_album,
                                              :admin_family_tree, :create_admin_family_tree]

  ALLOWED_RENDER_TABS = [
    'settings_general',
    'settings_change_password',
    'settings_info',
    'settings_social',
    'settings_notifications'
  ].freeze

  # GET /users
  def index
    @users = if params[:approved] == "false"
               User.where(approved: false)
             else
               User.where(approved: true)
             end
  end

  # POST /users/:id/approve
  def approve_as_admin
    @user = User.find(params[:id])
    @user.update(approved: true)

    flash[:notice] = "#{@user.full_name} has been approved."
    redirect_to users_path(approved: false)
  end

  # GET /admin_photo_album
  def admin_photo_album
    @admin_photo_album = PhotoAlbum.find_by(is_admin: true, admin_type: 'home_page_carousel')
  end

  # POST /create_admin_photo_album
  # rubocop: disable Metrics/AbcSize
  def create_admin_photo_album
    @user = current_user
    @photo_album = @user.photo_albums.new(photo_album_params.merge(name: "ADMIN PHOTO ALBUM",
                                                                   is_admin: true,
                                                                   admin_type: 'home_page_carousel'))
    if @photo_album.save
      flash[:success] = "Successfully created ADMIN PHOTO ALBUM"
      redirect_to admin_photo_album_path
    else
      flash.now[:error] = @photo_album.errors.messages.values.flatten.uniq
      render :admin_photo_album
    end
  end
  # rubocop: enable Metrics/AbcSize

  def update_admin_photo_album
    @photo_album = PhotoAlbum.find_by(is_admin: true, admin_type: 'home_page_carousel')

    if @photo_album.update(photo_album_params)
      flash[:success] = "Successfully updated #{@photo_album.name}"
      redirect_to admin_photo_album_path
    else
      flash.now[:error] = @photo_album.errors.messages.values.flatten.uniq
      render :admin_photo_album_path
    end
  end

  def destroy_photo_from_admin_photo_album
    @admin_photo_album = PhotoAlbum.find_by(is_admin: true, admin_type: 'home_page_carousel')
    @image = @admin_photo_album.images.find(params[:image_id])
    @image.purge

    redirect_to admin_photo_album_path
  end

  # GET /admin_family_tree
  def admin_family_tree
    @admin_family_tree = PhotoAlbum.find_by(is_admin: true, admin_type: 'family_tree')
  end

  # POST /create_admin_photo_album
  def create_admin_family_tree
    @user = current_user
    @family_tree = @user.photo_albums.new(photo_album_params.merge(name: "FAMILY TREE",
                                                                   is_admin: true,
                                                                   admin_type: 'family_tree'))
    if @family_tree.save
      flash[:success] = "Successfully uploaded a family tree image."
      redirect_to admin_family_tree_path
    else
      flash.now[:error] = @family_tree.errors.messages.values.flatten.uniq
      render :admin_family_tree
    end
  end

  # DELETE /family_tree_photo
  def destroy_family_tree_photo
    @family_tree_photo = PhotoAlbum.find_by(is_admin: true, admin_type: 'family_tree')
    @family_tree_photo.destroy

    redirect_to admin_family_tree_path
  end

  # PATCH /users/attach_avatar
  def attach_avatar
    current_user.update(user_params)
    redirect_to root_path
  end

  # GET /settings
  def settings
    @tab = params[:tab]
    @user = current_user

    render @tab ||= "settings_general"
  end

  # PATCH /users/update_settings
  def update_settings
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "Successfully updated settings"
      redirect_to settings_path(tab: @tab)
    else
      flash.now[:error] = @user.errors.messages.values.flatten.uniq
      render @tab ||= "settings_general"
    end
  end

  # PATCH /users/update_password
  # rubocop: disable Metrics/AbcSize
  def update_password
    @user = current_user
    unless @user.valid_password?(params[:user][:current_password])
      flash.now[:error] = "Current password is invalid"
      return render @tab
    end

    if @user.update(change_password_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      flash[:success] = "Successfully updated password."
      redirect_to settings_path(tab: @tab)
    else
      flash.now[:error] = @user.errors.messages.values.flatten.uniq
      render @tab
    end
  end
  # rubocop: enable Metrics/AbcSize

  private

  def user_params
    params.require(:user).permit(
      :avatar,
      :first_name,
      :last_name,
      :bio,
      :date_of_birth,
      :location,
      :occupation,
      :phone_number,
      :facebook,
      :instagram,
      :twitter,
      :linkedin,
      :is_notified_when_new_message_posted
    )
  end

  def change_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def photo_album_params
    params.require(:photo_album).permit(images: [])
  end

  # Brakeman Dynamic Render issue. This should protect against a user trying to access a template
  # they shouldn't have access to.
  def verify_allowed_render_tabs
    @tab = params[:tab]

    return if ALLOWED_RENDER_TABS.include?(@tab)

    redirect_to main_app.root_url, alert: 'Invalid access'
  end

  def verify_user_is_admin
    @user = current_user

    return if @user.admin?

    redirect_to main_app.root_url, alert: 'You are not authorized to view this page. '\
                                          'Please contact your administrator.'
  end
end
