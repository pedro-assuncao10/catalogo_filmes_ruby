class HomeController < ApplicationController
  def index
    @categories = Category.order(:name)
    
    scope = Movie.all
    
    scope = scope.search_by_query(params[:query]) if params[:query].present?
    scope = scope.search_by_year(params[:year]) if params[:year].present?
    scope = scope.search_by_category(params[:category_id]) if params[:category_id].present?

    scope = scope.order(created_at: :desc)
    
    #Pagina o resultado final
    @pagy, @movies = pagy(scope, items: 5)

    # Busca as 30 tags mais populares, contando quantos filmes cada uma tem.
    # O resultado é ordenado pela contagem, da maior para a menor.
    @tag_cloud = Tag.joins(:taggings)
                    .select('tags.name, count(taggings.tag_id) as movie_count')
                    .group('tags.id')
                    .order('movie_count DESC')
                    .limit(30)
  end
end

