class RecipeCommentsController < ApplicationController
  before_action :set_user

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.new(comment_params)
    return if @comment.save

    @error = true
    flash.now[:error] = "Please submit a comment."
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @recipe = Recipe.find(params[:recipe_id])
    @comment.destroy

    redirect_to recipe_path(@recipe)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :user_id)
  end

  def set_user
    @user = current_user
  end
end
