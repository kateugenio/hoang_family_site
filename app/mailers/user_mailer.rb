class UserMailer < ApplicationMailer
  def new_message_posted(posting_user_id, sending_to_user_id, message_id)
    @posting_user = User.find(posting_user_id)
    @sending_to_user = User.find(sending_to_user_id)
    @message = Message.find(message_id)
    make_bootstrap_mail(
      to: @sending_to_user.email,
      subject: "#{@posting_user.full_name} has posted a new message!"
    )
  end
end
