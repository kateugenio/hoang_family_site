class Message < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :subject, :body, presence: true

  after_create :send_approved_users_notification_email

  def send_approved_users_notification_email
    # TODO: Use sidekiq/redis to deliver emails in production
    User.where.not(id: user_id).non_admin_approved_users.each do |recipient_user|
      UserMailer.new_message_posted(user_id, recipient_user.id, id).deliver
    end
  end
end
