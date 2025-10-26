Rails.application.routes.draw do
  devise_for :users
  
  root "home#index"
  
  resources :movies do
    resources :comments, only: [:create]
  end

  resources :categories, except: [:show]

  resources :tags, only: [:show]

  # Rota da API para busca de filmes 
  namespace :api do
    get 'movies/search', to: 'movies#search'
  end

  # Rota para verificação de saúde da aplicação
  get "up" => "rails/health#show", as: :rails_health_check
end