require_relative 'deck'

class GoFish
  include ActiveModel::Serializers::JSON

  STARTING_HAND_SIZE = 5

  attr_accessor :deck, :current_player
  attr_reader :players

  def initialize(players:, deck: Deck.new, current_player: players.first)
    @players = players
    @deck = deck
    @current_player = current_player
  end

  def deal!
    deck.shuffle

    STARTING_HAND_SIZE.times do
      players.each { |player| player.add_to_hand(deck.deal) }
    end
  end

  def self.dump(object)
    object.as_json
  end

  def self.load(payload)
    return if payload.nil?

    players = payload['players'].map { |player_data| Player.load(player_data) }
    deck = Deck.load(payload['deck'])
    current_player = players.detect { |player| player.user_id == payload['current_player']['user_id'] }
    GoFish.new(players:, deck:, current_player:)
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    instance_values
  end
end
