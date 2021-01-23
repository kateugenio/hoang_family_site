class AddIsNotifiedWhenNewMessagePostedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_notified_when_new_message_posted, :boolean, default: true
  end
end
