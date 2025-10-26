class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :load_categories, only: [:new, :edit, :create, :update]

  def show

    tag_ids = @movie.tag_ids

    # Só executa a busca se o filme tiver alguma tag
    if tag_ids.any?
      # Busca outros filmes que tenham pelo menos uma das tags,
      # excluindo o próprio filme da lista de resultados,
      # pegando apenas resultados únicos e limitando a 5.
      @related_movies = Movie.joins(:tags)
                             .where(tags: { id: tag_ids })
                             .where.not(id: @movie.id)
                             .distinct
                             .limit(5)
    else
      # Se o filme não tiver tags, a lista de relacionados é vazia
      @related_movies = []
    end

  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = current_user.movies.build(movie_params)
    if @movie.save
      redirect_to @movie, notice: 'Filme cadastrado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Filme atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to root_path, notice: 'Filme apagado com sucesso.'
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: 'Você não tem permissão para esta ação.' unless @movie.user == current_user
  end

  def load_categories
    @categories = Category.order(:name)
  end

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :release_year, :duration, :director, :poster, :external_url, :tag_list, category_ids: [])
  end
end