class AddImagesToPhotoAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :photo_albums, :images, :string, array: true, default: []
  end
end
