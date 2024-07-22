class User < ApplicationRecord
  has_many :game_users
  has_many :games, through: :game_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def name
    email.split('@').first.capitalize
  end

  def wins
    games.select { |game| winner?(game) }.count
  end

  def losses
    games.select { |game| !winner?(game) && game.finished? }.count
  end

  def win_rate
    return 0 if total_games.zero?

    (wins.to_f / total_games * 100).round(2)
  end

  def total_games
    games.select(&:finished?).count
  end

  private

  def winner?(game)
    game.go_fish&.winner&.user_id == id
  end
end
