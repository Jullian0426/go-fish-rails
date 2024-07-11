require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:game) { create(:game) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  describe '#start!' do
    context 'when the required player count is not met' do
      it 'returns false' do
        expect(game.users.count).to eq(0)
        expect(game.enough_players?).to be false

        expect(game.start!).to be false
        expect(game.go_fish).to be_nil
      end
    end

    context 'when the required player count is met' do
      before do
        create(:game_user, game:, user: user1)
        create(:game_user, game:, user: user2)
      end

      it 'populates go_fish attribute' do
        expect(game.enough_players?).to be true
        expect(game.go_fish).to be_nil

        game.start!

        expect(game.go_fish).not_to be_nil
      end

      it 'initializes GoFish with the correct players' do
        game.start!
        go_fish = game.go_fish

        expect(go_fish.players.map(&:user_id)).to match_array([user1.id, user2.id])
      end

      it 'deals cards to players' do
        game.start!
        go_fish = game.go_fish

        go_fish.players.each do |player|
          expect(player.hand.size).to eq(GoFish::STARTING_HAND_SIZE)
        end
      end
    end
  end

  # TODO: specifically test go_fish
  describe '#go_fish' do

  end
end