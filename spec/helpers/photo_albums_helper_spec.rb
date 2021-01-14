require 'rails_helper'

RSpec.describe PhotoAlbumsHelper, type: :helper do
  before {
    @user = create(:user)
    @photo_album = create(:photo_album)
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
end
