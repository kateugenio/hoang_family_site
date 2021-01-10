class PhotoAlbum < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :name, presence: true
end
