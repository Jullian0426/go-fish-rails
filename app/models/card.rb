# frozen_string_literal: true

# Represents a playing card
class Card
  attr_reader :rank, :suit

  RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze
  SUITS = %w[Hearts Diamonds Clubs Spades].freeze

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def value
    RANKS.index(rank)
  end

  def self.from_json(card_data)
    return unless card_data

    rank = card_data['rank']
    suit = card_data['suit']
    Card.new(rank:, suit:)
  end

  def ==(other)
    other.is_a?(Card) && rank == other.rank && suit == other.suit
  end
end
