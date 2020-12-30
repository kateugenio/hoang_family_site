class RecipesController < ApplicationController
  before_action :set_user

  def index
    @recipes = Recipe.includes(:user).all
  end

  def new
    @recipe = @user.recipes.new
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def edit
    @recipe = Recipe.find(params[:id])
    authorize! :update, @recipe
  end

  # rubocop: disable Metrics/AbcSize
  def create
    @recipe = @user.recipes.new(recipe_params)

    if @recipe.save
      flash[:success] = "Successfully added #{@recipe.name}!"
      redirect_to recipes_path
    else
      flash[:error] = @recipe.errors.messages.values.flatten.uniq
      render :new
    end
  end
  # rubocop: enable Metrics/AbcSize

  # rubocop: disable Metrics/AbcSize
  def update
    @recipe = Recipe.find(params[:id])
    authorize! :update, @recipe

    if @recipe.update(recipe_params)
      flash[:success] = "Successfully updated #{@recipe.name}"
      redirect_to recipes_path
    else
      flash[:error] = @recipe.errors.messages.values.flatten.uniq
      render :edit
    end
  end
  # rubocop: enable Metrics/AbcSize

  def destroy
    @recipe = Recipe.find(params[:id])
    authorize! :destroy, @recipe
    @recipe.destroy

    redirect_to recipes_path
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :name,
      :ingredients,
      :directions,
      :category,
      :serving_size,
      :total_cook_time
    )
  end

  def set_user
    @user = current_user
  end
end
