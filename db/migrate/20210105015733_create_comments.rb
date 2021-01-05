class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.bigint  :commentable_id
      t.string  :commentable_type
      t.timestamps
    end
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
