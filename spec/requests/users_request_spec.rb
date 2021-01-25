require 'rails_helper'

RSpec.describe "Users", type: :request do
  before {
    @admin = create(:admin)
    @user = create(:user)
  }

  it 'renders index' do
    # Arrange
    sign_in @admin

    # Act
    get users_path

    # Assert
    expect(response).to render_template(:index)
  end

  it 'approve_as_admin post request' do
    # Arrange
    sign_in @admin
    @user.update(approved: false)

    # Act
    post approve_as_admin_path(@user)

    # Assert
    expect(response).to redirect_to(users_path(approved: false))
    expect(flash[:notice]).to include "#{@user.full_name} has been approved."
    expect(@user.reload.approved).to be true
  end

  it 'attaches user profile photo' do
    # Arrange
    sign_in @user
    photo = fixture_file_upload(file_fixture('avatar.png'))
    params = {
      user: {
        avatar: photo
      }
    }

    # Act
    patch attach_avatar_path, params: params

    # Arrange
    expect(response).to redirect_to(root_path)
    expect(@user.reload.avatar.attached?).to be true
  end

  describe '#settings' do
    before {
      sign_in @user
    }

    it 'renders settings_general template by default' do
      # Act
      get settings_path

      # Assert
      expect(response).to render_template(:settings_general)
    end

    it 'renders settings_change_password template' do
      # Act
      get settings_path(tab: 'settings_change_password')

      # Assert
      expect(response).to render_template(:settings_change_password)
    end

    it 'renders settings_info template' do
      # Act
      get settings_path(tab: 'settings_info')

      # Assert
      expect(response).to render_template(:settings_info)
    end

    it 'renders settings_social template' do
      # Act
      get settings_path(tab: 'settings_social')

      # Assert
      expect(response).to render_template(:settings_social)
    end

    it 'renders settings_notifications template' do
      # Act
      get settings_path(tab: 'settings_notifications')

      # Assert
      expect(response).to render_template(:settings_notifications)
    end
  end

  describe '#update_settings' do
    before {
      sign_in @user
    }

    it 'updates avatar, first_name, and last_name on General tab' do
      # Arrange
      photo = fixture_file_upload(file_fixture('avatar.png'))
      tab = 'settings_general'
      params = {
        tab: tab,
        user: {
          avatar: photo,
          first_name: 'Johnny',
          last_name: 'Appleseed'
        }
      }

      # Act
      patch update_settings_path, params: params

      # Assert
      expect(response).to redirect_to(settings_path(tab: tab))
      expect(@user.reload.first_name).to eq('Johnny')
      expect(@user.reload.last_name).to eq('Appleseed')
    end

    it 'renders flash error if invalid entry on General tab' do
      # Arrange
      tab = 'settings_general'
      params = {
        tab: tab,
        user: {
          first_name: '',
          last_name: 'Appleseed'
        }
      }

      # Act
      patch update_settings_path, params: params

      # Assert
      expect(response).to render_template(tab)
      expect(flash[:error]).to include 'First name cannot be blank'
    end

    it 'updates general info on Info tab' do
      # Arrange
      tab = 'settings_info'
      params = {
        tab: tab,
        user: {
          bio: 'a bio about me',
          location: 'Los Angeles, CA',
          occupation: 'Teacher'
        }
      }

      # Act
      patch update_settings_path, params: params

      # Assert
      expect(response).to redirect_to(settings_path(tab: tab))
      expect(@user.reload.bio).to eq('a bio about me')
      expect(@user.reload.location).to eq('Los Angeles, CA')
      expect(@user.reload.occupation).to eq('Teacher')
    end

    it 'updates social links on Social Links tab' do
      # Arrange
      tab = 'settings_social'
      params = {
        tab: tab,
        user: {
          twitter: '@coolio',
          facebook: 'www.facebook.com/coolio',
          instagram: '@coolio'
        }
      }

      # Act
      patch update_settings_path, params: params

      # Assert
      expect(response).to redirect_to(settings_path(tab: tab))
      expect(@user.reload.twitter).to eq('@coolio')
      expect(@user.reload.facebook).to eq('www.facebook.com/coolio')
      expect(@user.reload.instagram).to eq('@coolio')
    end

    it 'updates notificaiton options on Notifications tab' do
      # Arrange
      tab = 'settings_notifications'
      params = {
        tab: tab,
        user: {
          is_notified_when_new_message_posted: 0
        }
      }

      # Act
      patch update_settings_path, params: params

      # Assert
      expect(response).to redirect_to(settings_path(tab: tab))
      expect(@user.reload.is_notified_when_new_message_posted).to be false
    end
  end

  describe '#update_password' do
    before {
      sign_in @user
    }

    let(:tab) { 'settings_change_password' }

    it 'successfully updates' do
      # Arrange
      params = {
        tab: tab,
        user: {
          current_password: @user.password,
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      # Act
      patch update_password_path, params: params

      # Assert
      expect(response).to redirect_to(settings_path(tab: tab))
      expect(flash[:success]).to include 'Successfully updated password.'
    end

    it 'renders flash error if current_password is incorrect' do
      # Arrange
      params = {
        tab: tab,
        user: {
          current_password: 'wrong_password',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      # Act
      patch update_password_path, params: params

      # Assert
      expect(response).to render_template(tab)
      expect(flash[:error]).to include 'Current password is invalid'
    end

    it 'renders flash error if password and confirm_password do not match' do
      # Arrange
      params = {
        tab: tab,
        user: {
          current_password: @user.password,
          password: 'password123',
          password_confirmation: 'password789'
        }
      }

      # Act
      patch update_password_path, params: params

      # Assert
      expect(response).to render_template(tab)
      expect(flash[:error]).to include 'Password and Password Confirmation do not match'
    end

    it 'renders flash error if new password is blank' do
      # Arrange
      params = {
        tab: tab,
        user: {
          current_password: @user.password,
          password: '',
          password_confirmation: 'password789'
        }
      }

      # Act
      patch update_password_path, params: params

      # Assert
      expect(response).to render_template(tab)
      expect(flash[:error]).to include 'Password cannot be blank'
    end

    it 'renders flash error if new password is too short' do
      # Arrange
      params = {
        tab: tab,
        user: {
          current_password: @user.password,
          password: 'asdf',
          password_confirmation: 'asdf'
        }
      }

      # Act
      patch update_password_path, params: params

      # Assert
      expect(response).to render_template(tab)
      expect(flash[:error]).to include 'Password is too short (minimum is 6 characters)'
    end
  end

  describe '#admin_photo_album' do
    it 'successfully renders' do
      # Arrange
      sign_in @admin

      # Act
      get admin_photo_album_path

      # Assert
      expect(response).to render_template(:admin_photo_album)
    end

    it 'does not allow non-admin to access page' do
      # Arrange
      sign_in @user

      # Act
      get admin_photo_album_path

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include 'You are not authorized to view this page. '\
                                       'Please contact your administrator.'
    end
  end

  describe '#create_admin_photo_album' do
    it 'successfully creates' do
      # Arrange
      sign_in @admin
      image = fixture_file_upload(file_fixture('avatar.png'))
      params = {
        photo_album: {
          images: [image]
        }
      }

      # Assume
      expect(PhotoAlbum.find_by(is_admin: true)).to be nil

      # Act
      post create_admin_photo_album_path, params: params

      # Assert
      expect(response).to redirect_to(admin_photo_album_path)
      expect(PhotoAlbum.where(is_admin: true)).to exist
    end

    it 'does not allow non-admin to upload' do
      # Arrange
      sign_in @user
      image = fixture_file_upload(file_fixture('avatar.png'))
      params = {
        photo_album: {
          images: [image]
        }
      }

      # Assume
      expect(PhotoAlbum.find_by(is_admin: true)).to be nil

      # Act
      post create_admin_photo_album_path, params: params

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include 'You are not authorized to view this page. '\
                                       'Please contact your administrator.'
    end
  end
end
