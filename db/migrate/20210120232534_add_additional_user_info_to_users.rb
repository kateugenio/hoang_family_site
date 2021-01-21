class AddAdditionalUserInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :date_of_birth, :date
    add_column :users, :location, :string
    add_column :users, :occupation, :string
    add_column :users, :phone_number, :string
  end
end
