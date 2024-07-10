require_relative 'player'
require_relative 'go_fish'

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :required_player_count, presence: true, numericality: { only_integer: true, greater_than: 1 }

  serialize :go_fish, JSON, type: GoFish

  def enough_players?
    users.count == required_player_count
  end

  def start!
    return false unless required_player_count == users.count

    players = users.map { |user| Player.new(user.id) }
    go_fish = GoFish.new(players)
    go_fish.deal!
    update(go_fish: go_fish, started_at: Time.zone.now)
  end

  def play_round!
    go_fish.play_round!
    save!
  end
end
