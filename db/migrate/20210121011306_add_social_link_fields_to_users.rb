class AddSocialLinkFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
    add_column :users, :twitter, :string
    add_column :users, :linkedin, :string
  end
end
