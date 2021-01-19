class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_rich_text :ingredients
  has_rich_text :directions

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
  validates :serving_size, :total_cook_time, numericality: { greater_than: 0 }, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }
end
