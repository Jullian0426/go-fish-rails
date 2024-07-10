require 'rails_helper'

RSpec.describe GoFish, type: :model do
  let(:player1) { Player.new(1) }
  let(:player2) { Player.new(2) }
  let(:players) { [player1, player2] }

  let(:go_fish) { GoFish.new(players) }

  describe '#deal!' do
    it 'moves cards from deck to players' do
      go_fish.deal!

      expect(player1.hand.size).to eq(GoFish::STARTING_HAND_SIZE)
      expect(player2.hand.size).to eq(GoFish::STARTING_HAND_SIZE)
    end
  end
end