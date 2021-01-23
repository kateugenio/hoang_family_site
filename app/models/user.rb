class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  after_create :send_admin_mail

  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :photo_albums, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_one_attached :avatar

  validates :first_name, :last_name, :email, presence: true

  attr_accessor :current_password

  scope :non_admin_approved_users, -> { where(admin: false, approved: true) }
  scope :enables_new_message_posted_notifications, -> {
    where(is_notified_when_new_message_posted: true)
  }

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end

  def full_name
    [first_name, last_name].join(' ').squish
  end
end
