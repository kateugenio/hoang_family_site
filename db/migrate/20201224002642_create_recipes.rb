class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :ingredients
      t.text :directions
      t.string :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
