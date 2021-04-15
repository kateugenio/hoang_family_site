require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  before {
    @user = create(:user)
  }

  describe '#filtered_by' do
    let(:users_with_albums) { PhotoAlbum.filtered_users(@user) }

    it 'returns "My Albums"' do
      # Arrange
      params = { album: 'current_user' }

      # Act/Assert
      expect(helper.filtered_by(users_with_albums, params)).to eq('My Albums')
    end

    it 'returns "All Albums"' do
      # Arrange
      params = { album: 'all' }

      # Act/Assert
      expect(helper.filtered_by(users_with_albums, params)).to eq('All Albums')
    end
  end


  describe '#default_or_uploaded_avatar' do
    it 'returns "default-user-avatar" string if user avatar is not attached' do
      # Act/Assert
      expect(helper.default_or_uploaded_avatar(@user)).to eq('default-user-avatar')
    end

    it 'returns user avatar if attached' do
      # Arrange
      photo = fixture_file_upload(file_fixture('avatar.png'))
      @user.avatar.attach(photo)

      # Act/Assert
      expect(helper.default_or_uploaded_avatar(@user)).to eq(@user.reload.avatar)
    end
  end

  describe '#uri_scheme?' do
    it 'returns true if uri scheme present' do
      # Arrange
      urls = ['https://www.google.com', 'http://www.google.com']

      # Act/Assert
      urls.each do |url|
        expect(helper.uri_scheme?(url)).to be true
      end
    end

    it 'returns false if uri scheme is not present' do
      # Arrange
      urls = ['www.facebook.com', 'httttpp://www.facebook.com']

      # Act/Assert
      urls.each do |url|
        expect(helper.uri_scheme?(url)).to be false
      end
    end
  end

  describe '#external_site_url' do
    it 'prepends "https://" if not present' do
      # Arrange
      url = 'www.myprofile.com'

      # Act/Assert
      expect(helper.external_site_url(url)).to eq('https://www.myprofile.com')
    end
  end

  describe '#removed_social_media_at_sign' do
    it 'removes "@" sign if present in first position' do
      # Arrange
      handle = '@coolgirl22'

      # Act/Assert
      expect(helper.removed_social_media_at_sign(handle)).to eq('coolgirl22')
    end
  end
end
