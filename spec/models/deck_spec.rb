require 'rails_helper'

RSpec.describe Deck, type: :model do
  let(:cards) { [Card.new(rank: 'A', suit: 'Spades'), Card.new(rank: '2', suit: 'Hearts')] }
  let(:deck) { Deck.new(cards) }

  describe '#load' do
    it 'loads Deck object from json' do
      json_payload = deck.as_json
      loaded_deck = Deck.from_json(json_payload)

      expect(loaded_deck).not_to be_nil
      expect(loaded_deck.cards.map(&:as_json)).to match_array(deck.cards.map(&:as_json))
    end
  end
end