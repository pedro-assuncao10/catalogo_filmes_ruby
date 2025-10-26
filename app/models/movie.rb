class Movie < ApplicationRecord

  # Associações
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :poster
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  # Associações para o nosso sistema de tags
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :external_url, length: { maximum: 500 }, allow_blank: true
  validate :external_url_format

  def external_url_format
    return if external_url.blank?
    uri = URI.parse(external_url) rescue nil
    errors.add(:external_url, "deve ser uma URL válida (http ou https)") unless uri&.scheme.in?(%w[http https])
  end

  # Método para retornar as tags do filme como uma string
  def tag_list
    tags.map(&:name).join(', ')
  end

  # Método para receber uma string de tags do formulário
  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  # --- SCOPES DE FILTRO ---
  
  # Busca genérica por Título OU Diretor
  scope :search_by_query, ->(query) { 
    where("title ILIKE ? OR director ILIKE ?", "%#{query}%", "%#{query}%") 
  }
  
  # Busca por ano de lançamento
  scope :search_by_year, ->(year) { 
    where("CAST(release_year AS TEXT) ILIKE ?", "%#{year}%") 
  }
  
  # Filtra por ID de categoria
  scope :search_by_category, ->(category_id) { 
    joins(:categories).where(categories: { id: category_id }) 
  }

end

