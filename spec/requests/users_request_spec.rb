require 'rails_helper'

RSpec.describe "Users", type: :request do
  before { sign_in create(:admin) }

  it 'renders index' do
    # Act
    get users_path

    # Assert
    expect(response).to render_template(:index)
  end

  it 'approve_as_admin post request' do
    # Arrange
    user = create(:user, approved: false)

    # Act
    post approve_as_admin_path(user)

    # Assert
    expect(response).to redirect_to(users_path(approved: false))
    expect(flash[:notice]).to include "#{user.full_name} has been approved."
    expect(user.reload.approved).to be true
  end
end
