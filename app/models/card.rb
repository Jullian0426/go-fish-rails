# frozen_string_literal: true

# Represents a playing card
class Card
  attr_reader :rank, :suit

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[H D C S].freeze

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def self.from_json(card_data)
    rank = card_data['rank']
    suit = card_data['suit']
    Card.new(rank:, suit:)
  end

  def ==(other)
    other.is_a?(Card) && rank == other.rank && suit == other.suit
  end
end
