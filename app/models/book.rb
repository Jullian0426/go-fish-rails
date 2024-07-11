# frozen_string_literal: true

# Represents a book of playing cards
class Book
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def rank
    cards.first.rank
  end

  def self.load(book_data)
    cards = book_data['cards'].map { |card_data| Card.load(card_data) }
    Book.new(cards)
  end
end
