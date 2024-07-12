require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:cards) { [Card.new(rank: 'A', suit: 'Spades'), Card.new(rank: 'A', suit: 'Hearts')] }
  let(:book) { Book.new(cards) }

  describe '#load' do
    it 'loads Book object from json' do
      json_payload = book.as_json
      loaded_book = Book.from_json(json_payload)

      expect(loaded_book).not_to be_nil
      expect(loaded_book.cards.map(&:as_json)).to match_array(book.cards.map(&:as_json))
    end
  end
end