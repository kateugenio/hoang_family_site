class PhotoAlbumsController < ApplicationController
  before_action :set_user

  def index
    @photo_albums = if params[:my_albums]
                      @user.photo_albums.all
                    elsif params[:user]
                      user = User.find(params[:user])
                      user.photo_albums.all
                    else
                      PhotoAlbum.all
                    end
    @users_with_albums = PhotoAlbum.includes(:user).all.map { |pa| { id: pa.user.id, name: pa.user.full_name } }
      .uniq!
      .select { |pa| pa[:id] != @user.id }
  end

  def new
    @photo_album = @user.photo_albums.new
  end

  def edit
    @photo_album = @user.photo_albums.find(params[:id])
  end

  def show
    @photo_album = PhotoAlbum.find(params[:id])
  end

  def create
    @photo_album = @user.photo_albums.new(photo_album_params)

    if @photo_album.save
      flash[:success] = "Successfully created #{@photo_album.name}"
      redirect_to photo_albums_path
    else
      flash.now[:error] = @photo_album.errors.messages.values.flatten.uniq
      render :new
    end
  end

  def update
    @photo_album = @user.photo_albums.find(params[:id])
    authorize! :update, @photo_album

    if @photo_album.update(photo_album_params)
      flash[:success] = "Successfully updated #{@photo_album.name}"
      redirect_to photo_album_path(@photo_album)
    else
      flash.now[:error] = @photo_album.errors.messages.values.flatten.uniq
      render :edit
    end
  end

  private

  def photo_album_params
    params.require(:photo_album).permit(:name, :description, images: [])
  end

  def set_user
    @user = current_user
  end
end
