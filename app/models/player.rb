# frozen_string_literal: true

class Player
  attr_accessor :api_key, :hand, :books
  attr_reader :name

  def initialize(name)
    @name = name
    @api_key = SecureRandom.hex(10)
    @hand = []
    @books = []
  end

  def add_to_hand(*cards)
    cards.flatten.each { |card| hand << card }
  end

  def hand_has_rank?(rank)
    hand.any? { |card| card.rank == rank }
  end

  def remove_by_rank(rank)
    removed_cards = hand.select { |card| card.rank == rank }
    hand.reject! { |card| card.rank == rank }
    removed_cards
  end
end
