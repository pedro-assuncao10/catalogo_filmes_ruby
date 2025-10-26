# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def show
    @tag = Tag.find_by_name!(params[:id])
    @movies = @tag.movies.order(created_at: :desc)
  end
end