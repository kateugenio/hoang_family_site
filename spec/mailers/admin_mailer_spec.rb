require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  it 'delivers new_user_waiting_for_approval email' do
    # Arrange
    user = create(:user)
    email_count_before = ActionMailer::Base.deliveries.count

    # Act
    AdminMailer.new_user_waiting_for_approval(user.email).deliver_now

    # Assert
    expect(email_count_before + 1).to eq ActionMailer::Base.deliveries.count
  end
end
