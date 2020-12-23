require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  before { sign_in create(:user) }

  it 'renders dashboard' do
    # Act
    get dashboard_path

    # Assert
    expect(response).to render_template(:index)
  end
end
