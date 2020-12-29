class AddServingSizeTotalCookTimeToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :serving_size, :integer
    add_column :recipes, :total_cook_time, :integer
  end
end
