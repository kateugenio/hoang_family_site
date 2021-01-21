class UsersController < ApplicationController
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
    @tab = params[:tab]

    if @user.update(user_params)
      flash[:success] = "Successfully updated settings"
      redirect_to settings_path(tab: @tab)
    else
      flash.now[:error] = @user.errors.messages.values.flatten.uniq
      render @tab ||= "settings_general"
    end
  end

  # PATCH /users/update_password
  def update_password
    @user = current_user
    @tab = params[:tab]

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
      :linkedin
    )
  end

  def change_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
