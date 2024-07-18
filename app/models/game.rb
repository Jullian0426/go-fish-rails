require_relative 'player'
require_relative 'go_fish'

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :required_player_count, presence: true, numericality: { only_integer: true, greater_than: 1 }

  serialize :go_fish, coder: GoFish

  after_update_commit lambda {
    users.each do |user|
      broadcast_refresh_to "games:#{id}:users:#{user.id}"
    end
  }

  def enough_players?
    users.count == required_player_count
  end

  def started?
    !go_fish.nil?
  end

  def start!
    update(users:)
    return false unless required_player_count == users.count

    players = users.map { |user| Player.new(user_id: user.id) }
    go_fish = GoFish.new(players:)
    go_fish.deal!
    # update started_at: DateTime.current
    update(go_fish:)
  end

  def play_round!(opponent_user_id, rank)
    opponent = go_fish.players.find { |player| player.user_id == opponent_user_id }
    go_fish.play_round!(opponent, rank)
    save!
  end
end
