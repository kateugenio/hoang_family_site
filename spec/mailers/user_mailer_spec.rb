require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  it 'delivers new_message_posted email' do
    # Arrange
    user2 = create(:user2)
    message = create(:message)
    email_count_before = ActionMailer::Base.deliveries.count

    # Act
    UserMailer.new_message_posted(message.user.id, user2.id, message.id).deliver_now

    # Assert
    expect(email_count_before + 1).to eq ActionMailer::Base.deliveries.count
  end
end
