require 'rails_helper'

RSpec.describe "PhotoAlbums", type: :request do
  before {
    @user = create(:user)
    @photo_album = create(:photo_album)
    sign_in @user
  }

  it 'renders index' do
    # Act
    get photo_albums_path

    # Assert
    expect(response).to render_template(:index)
  end

  it 'renders new' do
    # Act
    get new_photo_album_path

    # Assert
    expect(response).to render_template(:new)
  end

  it 'renderes edit' do
    # Act
    get edit_photo_album_path(@photo_album)

    # Assert
    expect(response).to render_template(:edit)
  end

  it 'renders show' do
    # Act
    get photo_album_path(@photo_album)

    # Assert
    expect(response).to render_template(:show)
  end

  describe '#create' do
    let(:image) { fixture_file_upload(file_fixture('avatar.png')) }

    it 'successfully creates and attaches images' do
      # Arrange
      params = {
        photo_album: {
          name: 'My new album',
          description: 'Summer vacation',
          images: [image]
        }
      }
      photo_albums_before = PhotoAlbum.count

      # Act
      post photo_albums_path, params: params, headers: { 'content-type': 'multipart/form-data' }

      # Assert
      photo_album = PhotoAlbum.last
      expect(response).to redirect_to(photo_albums_path)
      expect(PhotoAlbum.count).to eq photo_albums_before + 1
      expect(photo_album.images.attached?).to be true
    end

    it 'renders flash error if invalid' do
      # Arrange
      params = {
        photo_album: {
          name: '',
          images: [image]
        }
      }
      photo_albums_before = PhotoAlbum.count

      # Act
      post photo_albums_path, params: params, headers: { 'content-type': 'multipart/form-data' }

      # Assert
      expect(response).to render_template(:new)
      expect(PhotoAlbum.count).to eq photo_albums_before
      expect(flash[:error]).to include 'Name cannot be blank'
    end
  end

  describe '#update' do
    let(:image) { fixture_file_upload(file_fixture('avatar.png')) }

    it 'updates successfully' do
      # Arrange
      params = {
        photo_album: {
          name: 'New album name',
          images: [image]
        }
      }

      # Act
      patch photo_album_path(@photo_album), params: params,
                                            headers: { 'content-type': 'multipart/form-data' }

      # Assert
      expect(response).to redirect_to(photo_album_path(@photo_album))
      expect(@photo_album.reload.name).to eq('New album name')
    end

    it 'renders flash error if invalid' do
      # Arrange
      params = {
        photo_album: {
          name: '',
          images: [image]
        }
      }

      # Act
      patch photo_album_path(@photo_album), params: params,
                                            headers: { 'content-type': 'multipart/form-data' }

      # Assert
      expect(response).to render_template(:edit)
      expect(flash[:error]).to include 'Name cannot be blank'
    end

    it 'does not allow to update photo album if unauthorized' do
      # Arrange
      photo_album = create(:photo_album2)
      params = { photo_album: { name: 'new name' } }

      # Assume
      expect(photo_album.user).not_to eq(@user)

      # Act
      patch photo_album_path(photo_album), params: params,
                                           headers: { 'content-type': 'multipart/form-data' }

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end
end
