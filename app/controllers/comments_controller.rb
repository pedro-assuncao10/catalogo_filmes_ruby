class CommentsController < ApplicationController
    # Antes de qualquer ação, encontra o filme ao qual o comentário pertence
    before_action :set_movie
  
    def create
      @comment = @movie.comments.build(comment_params)
  
      # Se o usuário estiver logado, associa o comentário a ele
      if user_signed_in?
        @comment.user = current_user
        # Se o usuário estiver logado, usa o nome de usuário dele
        # (Assumindo que seu modelo User tem um campo 'name')
        @comment.name = current_user.name
      end
  
      if @comment.save
        redirect_to @movie, notice: 'Comentário adicionado com sucesso.'
      else
        # Se falhar, renderiza a página do filme novamente
        redirect_to @movie, alert: 'Erro ao adicionar comentário. O conteúdo não pode ficar em branco.'
      end
    end
  
    private
  
    # Encontra o filme com base no :movie_id da URL
    def set_movie
      @movie = Movie.find(params[:movie_id])
    end
  
    def comment_params
      params.require(:comment).permit(:content, :name)
    end
end
  
  