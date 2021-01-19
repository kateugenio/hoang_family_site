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
    @user = current_user
  end

  def update_settings
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "Successfully updated settings"
      redirect_to settings_path
    else
      flash.now[:error] = @user.errors.messages.values.flatten.uniq
      render :settings
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :first_name, :last_name)
  end
end
