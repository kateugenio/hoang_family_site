class Message < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :subject, :body, presence: true

  after_create :send_new_message_posted_email

  def send_new_message_posted_email
    # TODO: Use sidekiq/redis to deliver emails in production
    User.where.not(id: user_id)
        .non_admin_approved_users
        .enables_new_message_posted_notifications.each do |recipient_user|
      UserMailer.delay.new_message_posted(user_id, recipient_user.id, id)
    end
  end
end
