class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_category, only: [:edit, :update, :destroy]
  
    def index
      @categories = Category.order(:name)
      @category = Category.new 
    end
  
    
    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to categories_path, notice: 'Categoria criada com sucesso.'
      else
        # Se falhar, renderiza o 'index' novamente, mostrando os erros
        @categories = Category.order(:name)
        render :index, status: :unprocessable_entity
      end
    end
  
    def edit
      # @category é carregado pelo set_category
    end
  
    def update
      if @category.update(category_params)
        redirect_to categories_path, notice: 'Categoria atualizada com sucesso.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @category.destroy
      redirect_to categories_path, notice: 'Categoria apagada com sucesso.'
    end
  
    private
  
    def set_category
      @category = Category.find(params[:id])
    end
  
    def category_params
      params.require(:category).permit(:name)
    end
  end
  