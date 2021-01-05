class RecipesController < ApplicationController
  before_action :set_user

  # GET /recipes
  def index
    @recipes = Recipe.includes(:user).all
  end

  # GET /recipes/new
  def new
    @recipe = @user.recipes.new
  end

  # GET /recipes/:id
  def show
    @recipe = Recipe.includes(:comments, :user).find(params[:id])
  end

  # GET /recipes/:id/edit
  def edit
    @recipe = Recipe.find(params[:id])
    authorize! :update, @recipe
  end

  # POST /recipes
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

  # PATCH /recipes/:id
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

  # DELETE /recipes/:id
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
