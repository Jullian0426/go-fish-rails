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

    # TODO: delegate responsibilities to classes
    players = load_players(payload['players'])
    deck = load_deck(payload['deck'])
    current_player = players.detect { |player| player.user_id == payload['current_player']['user_id'] }
    GoFish.new(players:, deck:, current_player:)
  end

  def self.load_deck(deck_data)
    cards = deck_data['cards'].map { |card_data| load_card(card_data) }
    Deck.new(cards)
  end

  def self.load_players(players_data)
    players_data.map do |player_data|
      user_id = player_data['user_id']
      hand = player_data['hand'].map { |card_data| load_card(card_data) }
      books = player_data['books'].map { |book_data| load_book(book_data) }
      Player.new(user_id:, hand:, books:)
    end
  end

  def self.load_card(card_data)
    rank = card_data['rank']
    suit = card_data['suit']
    Card.new(rank:, suit:)
  end

  def self.load_book(book_data)
    cards = book_data['cards'].map { |card_data| load_card(card_data) }
    Book.new(cards)
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
