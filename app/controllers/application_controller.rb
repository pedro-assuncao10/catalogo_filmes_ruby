class ApplicationController < ActionController::Base
  include Pagy::Backend
  allow_browser versions: :modern
  stale_when_importmap_changes
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :load_layout_collections

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    new_movie_path
  end

  private

  def load_layout_collections
    return unless request.format.html?
    @categories = Category.order(:name)
  end
end
