class Category < ApplicationRecord
    # Validação: Garante que o nome da categoria não pode estar em branco
    validates :name, presence: true, uniqueness: { case_sensitive: false }
  
    # --- ASSOCIAÇÕES DE CATEGORIA ---
    # Uma categoria tem muitas "ligações" (categorizations)
    has_many :categorizations, dependent: :destroy
    # Uma categoria tem muitos "filmes" *através* dessas ligações
    has_many :movies, through: :categorizations
  end
  