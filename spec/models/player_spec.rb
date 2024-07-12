require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:user_id) { 1 }
  let(:hand) { [Card.new(rank: 'A', suit: 'Spades'), Card.new(rank: '2', suit: 'Hearts')] }
  let(:books) { [Book.new([hand.first])] }
  let(:player) { Player.new(user_id:, hand:, books:) }

  describe '#load' do
    it 'loads Player object from json' do
      json_payload = player.as_json
      loaded_player = Player.from_json(json_payload)

      expect(loaded_player).not_to be_nil
      expect(loaded_player.user_id).to eq(player.user_id)
      expect(loaded_player.hand.map(&:as_json)).to match_array(player.hand.map(&:as_json))
      expect(loaded_player.books.map(&:as_json)).to match_array(player.books.map(&:as_json))
    end
  end
end
