class AddIsAdminToPhotoAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :photo_albums, :is_admin, :boolean, default: false
  end
end
