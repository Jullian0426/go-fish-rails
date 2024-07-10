require_relative 'deck'

class GoFish
  attr_accessor :deck, :current_player
  attr_reader :players

  def initialize(players)
    @players = players
    @deck = Deck.new
    @current_player = players.first
  end

  def deal!
    deck.shuffle

    STARTING_HAND_SIZE.times do
      players.each { |player| player.add_to_hand(deck.deal) }
    end
  end

  STARTING_HAND_SIZE = 5
end
