class User < ApplicationRecord
  has_many :game_users
  has_many :games, through: :game_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save :set_name

  def set_name
    self.name = email.split('@').first.capitalize
  end

  def wins
    game_users.select(&:winner).size
  end

  def losses
    game_users.reject(&:winner).size
  end

  def win_rate
    return 0 if total_games.zero?

    (wins.to_f / total_games * 100).round(2)
  end

  def total_games
    wins + losses
  end

  def time_played
    finished_games = games.reject { |game| game.finished_at.nil? }
    total_seconds = finished_games.sum { |game| game.finished_at - game.started_at }
    format_time(total_seconds)
  end

  def total_score
    game_users.sum { |game_user| game_user.score || 0 }
  end

  private

  def format_time(seconds)
    if seconds >= 3600
      hours = (seconds / 3600).to_i
      minutes = ((seconds % 3600) / 60).to_i
      "#{hours}h:#{minutes}m"
    elsif seconds >= 60
      minutes = (seconds / 60).to_i
      remaining_seconds = (seconds % 60).to_i
      "#{minutes}m:#{remaining_seconds}s"
    else
      "#{seconds.to_i}s"
    end
  end
end
