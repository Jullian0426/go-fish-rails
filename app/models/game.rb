require_relative 'player'
require_relative 'go_fish'

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :required_player_count, presence: true, numericality: { only_integer: true, greater_than: 1 }

  serialize :go_fish, coder: GoFish

  def enough_players?
    users.count == required_player_count
  end

  def start!
    return false unless required_player_count == users.count

    players = users.map { |user| Player.new(user_id: user.id) }
    go_fish = GoFish.new(players:)
    go_fish.deal!
    # update started_at: DateTime.current
    update(go_fish:)
  end

  def play_round!
    go_fish.play_round!
    save!
  end
end
