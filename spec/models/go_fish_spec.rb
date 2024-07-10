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

  # TODO: use json_matcher to make tests more robust
  describe 'serialization' do
    it 'dumps GoFish data as json' do
      dump = GoFish.dump(go_fish)
      expect(dump).not_to be_nil
    end

    it 'loads GoFish object from json' do
      payload = go_fish.as_json

      load = GoFish.load(payload)
      expect(load).not_to be_nil
    end
  end
end
