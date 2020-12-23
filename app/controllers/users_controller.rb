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
end
