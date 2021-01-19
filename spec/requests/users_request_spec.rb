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

  it 'renders settings page' do
    # Arrange
    sign_in @user

    # Act
    get settings_path

    # Assert
    expect(response).to render_template(:settings)
  end

  describe '#update_settings' do
    it 'updates avatar, first_name, and last_name on settings page/general tab' do
      # Arrange
      sign_in @user
      photo = fixture_file_upload(file_fixture('avatar.png'))
      params = {
        user: {
          avatar: photo,
          first_name: 'Johnny',
          last_name: 'Appleseed'
        }
      }

      # Act
      patch update_settings_path, params: params

      # Assert
      expect(response).to redirect_to(settings_path)
      expect(@user.reload.first_name).to eq('Johnny')
      expect(@user.reload.last_name).to eq('Appleseed')
    end

    it 'renders flash error if invalid entry on settings/page general tab' do
      # Arrange
      sign_in @user
      params = {
        user: {
          first_name: '',
          last_name: 'Appleseed'
        }
      }

      # Act
      patch update_settings_path, params: params

      # Assert
      expect(response).to render_template(:settings)
      expect(flash[:error]).to include 'First name cannot be blank'
    end
  end
end
