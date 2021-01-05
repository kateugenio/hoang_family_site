require 'rails_helper'

RSpec.describe "RecipeComments", type: :request do
  before {
    @user = create(:user)
    @recipe = create(:recipe)
    sign_in @user
  }

  describe '#create' do
    it 'creates successfully' do
      # Arrange
      params = {
        comment: {
          comment: 'Best dessert ever',
          user_id: @user.id
        }
      }
      comments_before = @recipe.comments.count

      # Act
      post recipe_comments_path(@recipe, params: params), xhr: true

      # Assert
      expect(response).to render_template(:create)
      expect(@recipe.comments.count).to eq comments_before + 1
    end

    it 'flashes error message if unsuccessful' do
      # Arrange
      params = {
        comment: {
          comment: '',
          user_id: @user.id
        }
      }
      comments_before = @recipe.comments.count

      # Act
      post recipe_comments_path(@recipe, params: params), xhr: true

      # Assert
      expect(response).to render_template(:create)
      expect(@recipe.comments.count).to eq comments_before
      expect(flash[:error]).to include 'Please submit a comment.'
    end
  end

  describe '#destroy' do
    it 'destroys successfully' do
      # Arrange
      comment = create(:comment)
      recipe = comment.commentable
      comments_before = recipe.comments.count

      # Act
      delete recipe_comment_destroy_path(recipe, comment)

      # Assert
      expect(response).to redirect_to(recipe_path(recipe))
      expect(recipe.comments.count).to eq(comments_before - 1)
    end

    it 'does not allow to delete recipe if unauthorized' do
      # Arrange
      comment = create(:comment)
      sign_out @user
      other_user = create(:user2)
      sign_in other_user
      recipe = comment.commentable

      # Act
      delete recipe_comment_destroy_path(recipe, comment)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end
end
