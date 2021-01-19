require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  before {
    @user = create(:user)
    sign_in @user
  }

  it 'renders dashboard' do
    # Act
    get dashboard_path

    # Assert
    expect(response).to render_template(:index)
  end

  describe 'new_user_welcome_modal' do
    it 'renders modal if user sign_in_count is 1' do
      # Assume
      expect(@user.sign_in_count).to eq(0)

      # Act
      get dashboard_path

      # Assert
      expect(@user.reload.sign_in_count).to eq(1)
      expect(response).to render_template(partial: '_new_user_welcome_modal')
    end

    it 'does not render modal after initial sign in' do
      # Arrange
      @user.update(sign_in_count: 2)

      # Act
      get dashboard_path

      # Assert
      expect(response).not_to render_template(partial: '_new_user_welcome_modal')
    end
  end
end
