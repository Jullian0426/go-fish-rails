require 'rails_helper'

RSpec.describe GoFish, type: :model do
  let(:player1) { Player.new(user_id: 1) }
  let(:player2) { Player.new(user_id: 2) }
  let(:players) { [player1, player2] }

  let(:go_fish) { GoFish.new(players:) }

  describe '#deal!' do
    it 'moves cards from deck to players' do
      go_fish.deal!

      expect(player1.hand.size).to eq(GoFish::STARTING_HAND_SIZE)
      expect(player2.hand.size).to eq(GoFish::STARTING_HAND_SIZE)
    end
  end

  describe 'serialization' do
    context '#dump' do
      it 'dumps GoFish data as json' do
        dump = GoFish.dump(go_fish)
        expect(dump).not_to be(Hash)
      end
    end

    context '#load' do
      it 'loads GoFish object from json' do
        json_payload = go_fish.as_json
        loaded_go_fish = GoFish.load(json_payload)

        expect(loaded_go_fish).not_to be_nil
        expect(loaded_go_fish.players.map(&:user_id)).to match_array(go_fish.players.map(&:user_id))
        expect(loaded_go_fish.deck.cards).to match_array(go_fish.deck.cards)
        expect(loaded_go_fish.current_player.user_id).to eq(go_fish.current_player.user_id)
      end
    end
  end
end
