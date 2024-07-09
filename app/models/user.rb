class User < ApplicationRecord
  has_many :game_users
  has_many :games, through: :game_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def name
    email.split('@').first.capitalize
  end
end
