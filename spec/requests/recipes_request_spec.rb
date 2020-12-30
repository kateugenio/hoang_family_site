require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  before { sign_in create(:user) }

  it 'renders index' do
    # Act
    get recipes_path

    # Assert
    expect(response).to render_template(:index)
  end

  it 'renders new' do
    # Act
    get new_recipe_path

    # Assert
    expect(response).to render_template(:new)
  end

  it 'renders show' do
    # Arrange
    recipe = create(:recipe)

    # Act
    get recipe_path(recipe)

    # Assert
    expect(response).to render_template(:show)
  end

  describe '#create' do
    it 'creates successfully' do
      # Arrange
      params = {
        recipe: {
          name: 'Pot Roast',
          ingredients: 'the ingredients',
          directions: 'some directions',
          category: 'beef'
        }
      }
      recipes_before = Recipe.count

      # Act
      post recipes_path(params)

      # Assert
      expect(response).to redirect_to(recipes_path)
      expect(Recipe.count).to eq recipes_before + 1
    end

    it 'renders flash error if unsuccessful' do
      # Arrange
      params = {
        recipe: {
          name: '',
          ingredients: 'the ingredients',
          directions: 'some directions',
          category: ''
        }
      }
      recipes_before = Recipe.count

      # Act
      post recipes_path(params)

      # Assert
      expect(response).to render_template(:new)
      expect(Recipe.count).to eq recipes_before
      expect(flash[:error]).to include 'Name cannot be blank'
      expect(flash[:error]).to include 'Please select a category'
    end
  end
end
