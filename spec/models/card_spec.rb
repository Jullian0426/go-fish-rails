require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:card) { Card.new(rank: 'A', suit: 'Spades') }

  describe '#load' do
    it 'loads Card object from json' do
      json_payload = card.as_json
      loaded_card = Card.load(json_payload)

      expect(loaded_card).not_to be_nil
      expect(loaded_card.rank).to eq(card.rank)
      expect(loaded_card.suit).to eq(card.suit)
    end
  end
end