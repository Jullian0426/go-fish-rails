# frozen_string_literal: true

require_relative 'card'

# Represents a deck of cards
class Deck
  attr_accessor :cards

  def initialize(cards = make_cards)
    @cards = cards
  end

  def shuffle!(seed = Random.new)
    cards.shuffle!(random: seed)
  end

  def make_cards
    Card::SUITS.flat_map do |suit|
      Card::RANKS.map do |rank|
        Card.new(rank:, suit:)
      end
    end
  end

  def deal
    cards.pop
  end

  def self.from_json(deck_data)
    cards = deck_data['cards'].map { |card_data| Card.from_json(card_data) }
    Deck.new(cards)
  end
end
