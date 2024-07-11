# frozen_string_literal: true

class Player
  attr_accessor :hand, :books
  attr_reader :user_id

  def initialize(user_id:, hand: [], books: [])
    @user_id = user_id
    @hand = hand
    @books = books
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

  def self.load(player_data)
    user_id = player_data['user_id']
    hand = player_data['hand'].map { |card_data| Card.load(card_data) }
    books = player_data['books'].map { |book_data| Book.load(book_data) }
    Player.new(user_id:, hand:, books:)
  end
end
