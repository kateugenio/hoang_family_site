require 'rails_helper'

RSpec.describe User, type: :model do
  it 'sends admin new_user_waiting_for_approval email after create' do
    # Assume
    mailers_before = ActionMailer::Base.deliveries.count
    expect(mailers_before).to be(0)

    # Act
    User.create(first_name: 'John', last_name: 'Snow', email: 'jsnow@abc.com', password: 'password')

    # Assert
    mailers_after = ActionMailer::Base.deliveries.count
    expect(mailers_after).to be(1)
  end
end
