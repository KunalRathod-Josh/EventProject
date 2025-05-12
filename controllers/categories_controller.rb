class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show, :update, :destroy ]
  load_and_authorize_resource

  def index
    @categories = Category.all
    render json: @categories
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    render json: { message: "Category deleted successfully" }
  end

  def set_category
    @category = Category.find_by(id: params[:id])
    render json: { error: "Category not found" }, status: :not_found unless @category
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
