class Recipe < ApplicationRecord
  belongs_to :user

  CATEGORIES = [
    'pork',
    'chicken',
    'eggs',
    'beef',
    'seafood',
    'soup',
    'vegetarian/vegan',
    'appetizers',
    'desserts',
    'noodles/pasta'
  ].freeze

  validates :name, :ingredients, :directions, :category, presence: true
  # validates :serving_size, :total_cook_time, numericality: { greater_than: 0 }
  validates :category, inclusion: { in: CATEGORIES }
end
