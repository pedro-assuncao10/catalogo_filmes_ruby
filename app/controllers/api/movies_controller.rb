# app/controllers/api/movies_controller.rb

require 'httparty'

class Api::MoviesController < ApplicationController
  # URL base da API do TMDb
  TMDb_BASE_URL = "https://api.themoviedb.org/3"
  # Sua chave da API, armazenada de forma segura
  TMDb_API_KEY = Rails.application.credentials.tmdb[:api_key]

  def search
    title = params[:title] # Pega o título enviado pelo frontend

    unless title.present?
      render json: { error: "O título do filme é obrigatório" }, status: :bad_request
      return
    end

    begin
      # 1. Primeira chamada: Buscar o filme pelo título para obter o ID
      search_response = HTTParty.get("#{TMDb_BASE_URL}/search/movie", query: {
        api_key: TMDb_API_KEY,
        query: title,
        language: 'pt-BR'
      })

      unless search_response.success? && search_response.parsed_response["results"].present?
        render json: { error: "Filme não encontrado" }, status: :not_found
        return
      end

      # Pega o primeiro e mais relevante resultado
      first_movie = search_response.parsed_response["results"].first
      movie_id = first_movie["id"]

      # 2. Segunda chamada: Buscar os detalhes completos do filme usando o ID
      details_response = HTTParty.get("#{TMDb_BASE_URL}/movie/#{movie_id}", query: {
        api_key: TMDb_API_KEY,
        language: 'pt-BR'
      })

      unless details_response.success?
        render json: { error: "Não foi possível obter os detalhes do filme" }, status: :internal_server_error
        return
      end

      movie_details = details_response.parsed_response

      # Monta o JSON de resposta com os dados que precisamos
      movie_data = {
        synopsis: movie_details["overview"],
        release_year: movie_details["release_date"]&.split('-')&.first, # Pega apenas o ano
        duration: movie_details["runtime"], # Duração em minutos
        director: get_director(movie_id) # O diretor precisa de uma chamada extra
      }

      render json: movie_data, status: :ok

    rescue HTTParty::Error, SocketError => e
      # Erro de conexão com a API do TMDb
      render json: { error: "Erro de comunicação com o serviço de busca. Tente novamente.", details: e.message }, status: :service_unavailable
    end
  end

  private

  # Função auxiliar para pegar o nome do diretor
  def get_director(movie_id)
    credits_response = HTTParty.get("#{TMDb_BASE_URL}/movie/#{movie_id}/credits", query: { api_key: TMDb_API_KEY })
    return "Não encontrado" unless credits_response.success?

    director = credits_response.parsed_response["crew"].find { |person| person["job"] == "Director" }
    director ? director["name"] : "Não encontrado"
  end
end