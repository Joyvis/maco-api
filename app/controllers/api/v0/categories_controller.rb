class Api::V0::CategoriesController < ApplicationController
  def index
    render json: Category.all
  end

  def create
    category = Category.create!(category_params)
    render json: category, status: :created
  end

  def update
    category = Category.find(params[:id])
    category.update!(category_params)
    render json: category
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy!
    head :no_content
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
