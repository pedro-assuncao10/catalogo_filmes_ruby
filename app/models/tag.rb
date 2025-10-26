class Tag < ApplicationRecord
    has_many :taggings, dependent: :destroy
    has_many :movies, through: :taggings
  
    # Garante que as tags sejam salvas em minúsculo e sem duplicatas
    before_save { self.name = name.downcase }
    validates :name, presence: true, uniqueness: { case_sensitive: false }
  end