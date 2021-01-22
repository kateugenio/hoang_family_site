require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:body) }
  end

  it 'sends non-admin/approved users new_message_posted email after create' do
    # Assume
    mailers_before = ActionMailer::Base.deliveries.count
    user = create(:user)
    expect(mailers_before).to be(0)
    non_admin_approved_users_count = User.non_admin_approved_users.count

    # Act
    Message.create(subject: 'New message', body: 'body', user_id: user.id)

    # Assert
    mailers_after = ActionMailer::Base.deliveries.count
    expect(mailers_after).to be(non_admin_approved_users_count)
  end
end
