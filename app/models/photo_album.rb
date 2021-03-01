class PhotoAlbum < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :name, presence: true

  paginates_per 8

  def self.filtered_users(current_user)
    includes(:user).all.map { |pa| { id: pa.user.id, name: pa.user.full_name } }
                   .uniq
                   .reject { |pa| pa[:id] == current_user.id }
  end
end
