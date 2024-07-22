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

  def value
    cards.first.value
  end

  def self.from_json(book_data)
    cards = book_data['cards'].map { |card_data| Card.from_json(card_data) }
    Book.new(cards)
  end
end
