class AddAdminAlbumTypeToPhotoAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :photo_albums, :admin_type, :string
  end
end
