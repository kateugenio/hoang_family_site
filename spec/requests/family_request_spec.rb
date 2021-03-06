require 'rails_helper'

RSpec.describe "Families", type: :request do
  before {
    @user = create(:user)
    sign_in @user
  }

  it 'renders tree' do
    # Act
    get family_tree_path

    # Assert
    expect(response).to render_template(:tree)
  end

  it 'renders bios' do
    # Act
    get family_bios_path

    # Assert
    expect(response).to render_template(:bios)
  end
end
