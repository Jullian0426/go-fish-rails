require_relative 'player'
require_relative 'go_fish'

class Game < ApplicationRecord
  class GoFishError < StandardError; end

  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :required_player_count, presence: true, numericality: { only_integer: true, greater_than: 1 }

  serialize :go_fish, coder: GoFish

  scope :joinable, -> { order(created_at: :desc).where(started_at: nil) }
  paginates_per 10

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

  def finished?
    go_fish.winners.any?
  end

  def can_take_turn?(current_user)
    go_fish.current_player.user_id == current_user.id && go_fish.winners.empty?
  end

  def start!
    update(users:)
    return false unless required_player_count == users.count

    players = users.map { |user| Player.new(user_id: user.id) }
    go_fish = GoFish.new(players:)
    go_fish.deal!
    # update started_at: DateTime.current
    update(go_fish:, started_at: DateTime.current)
  end

  def play_round!(opponent_user_id, rank)
    opponent = go_fish.players.find { |player| player.user_id == opponent_user_id }
    go_fish.play_round!(opponent, rank)
    complete_round
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def generate_score(game_user)
    player = go_fish.players.find { |p| p.user_id == game_user.user_id }
    player.books.sum(&:value)
  end

  private

  def complete_round
    if finished?
      winner_ids = go_fish.winners.map(&:user_id)

      game_users.each do |game_user|
        update_game_user(game_user, winner_ids)
      end

      update(finished_at: DateTime.current)
    else
      save!
    end
  end

  def update_game_user(game_user, winner_ids)
    is_winner = winner_ids.include?(game_user.user_id)
    score = is_winner ? generate_score(game_user) : 0
    game_user.update(winner: is_winner, score:)
  end
end
