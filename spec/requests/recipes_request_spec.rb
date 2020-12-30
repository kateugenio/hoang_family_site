require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  before {
    @user = create(:user)
    sign_in @user
  }

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

  describe '#edit' do
    it 'renders edit' do
      # Arrange
      recipe = create(:recipe)

      # Act
      get edit_recipe_path(recipe)

      # Assert
      expect(response).to render_template(:edit)
    end

    it 'does not allow to view edit recipe page if not authorized' do
      # Arrange
      recipe = create(:recipe2)

      # Assume
      expect(recipe.user).not_to eq(@user)

      # Act
      get edit_recipe_path(recipe)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
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

  describe '#update' do
    it 'updates successfuly' do
      # Arrange
      recipe = create(:recipe)
      params = { recipe: { ingredients: 'updated ingredients' } }

      # Act
      patch recipe_path(recipe, params: params)

      # Assert
      expect(response).to redirect_to(recipes_path)
      expect(recipe.reload.ingredients).to eq('updated ingredients')
    end

    it 'renders flash error if invalid update' do
      # Arrange
      recipe = create(:recipe)
      params = { recipe: { ingredients: '' } }

      # Act
      patch recipe_path(recipe, params: params)

      # Assert
      expect(response).to render_template(:edit)
      expect(flash[:error]).to include 'Must provide ingredients list'
    end

    it 'does not allow to update recipe if unauthorized' do
      # Arrange
      recipe = create(:recipe2)
      params = { recipe: { ingredients: 'new ingredients' } }

      # Assume
      expect(recipe.user).not_to eq(@user)

      # Act
      patch recipe_path(recipe, params: params)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end

  describe '#destroy' do
    it 'destroys successfully' do
      # Arrange
      recipe = create(:recipe)

      # Act
      delete recipe_path(recipe)

      # Assert
      expect(response).to redirect_to(recipes_path)
    end

    it 'does not allow to delete recipe if unauthorized' do
      # Arrange
      recipe = create(:recipe2)

      # Assume
      expect(recipe.user).not_to eq(@user)

      # Act
      delete recipe_path(recipe)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end
end
