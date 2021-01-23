require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe '#send_new_message_posted_email' do
    it 'sends non-admin/approved users new_message_posted email after create' do
      # Arrange
      mailers_before = ActionMailer::Base.deliveries.count
      user = create(:user)
      non_admin_approved_users_count = User.non_admin_approved_users.count

      # Assume
      expect(mailers_before).to be(0)

      # Act
      Message.create(subject: 'New message', body: 'body', user_id: user.id)

      # Assert
      mailers_after = ActionMailer::Base.deliveries.count
      expect(mailers_after).to eq(non_admin_approved_users_count)
    end

    it 'does not send new_message_posted email to users that opt-out of this notification' do
      # Arrange
      user = create(:user)
      user2 = create(:user2)
      user.update(is_notified_when_new_message_posted: false)
      expected_mailer_count = User.non_admin_approved_users
                                  .enables_new_message_posted_notifications
                                  .count

      # Assume
      expect(user2.is_notified_when_new_message_posted).to be true
      expect(user.is_notified_when_new_message_posted).to be false

      # Act
      Message.create(subject: 'New message', body: 'body', user_id: user2.id)

      # Assert
      expect(expected_mailer_count).to eq(1)
    end
  end
end
