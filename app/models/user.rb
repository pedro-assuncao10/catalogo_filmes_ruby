class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Adiciona a associação: "Um usuário tem muitos filmes"
  # Isso criará o método `.movies` que estava faltando.
  has_many :movies

  # Adiciona a associação: "Um usuário tem muitos comentários"
  has_many :comments
end
