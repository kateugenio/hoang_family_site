require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  it 'renders dashboard' do
    # Act
    get dashboard_path

    # Assert
    expect(response).to render_template(:index)
  end
end
