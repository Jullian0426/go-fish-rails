require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    create_game_with_result(user1, user2, user1) # user1 wins
    create_game_with_result(user1, user2, user2) # user2 wins
    create_game_with_result(user1, user2, nil) # unfinished game
  end

  describe '#wins' do
    it 'returns the correct number of wins' do
      expect(user1.wins).to eq(1)
    end
  end

  describe '#losses' do
    it 'returns the correct number of losses' do
      expect(user1.losses).to eq(1)
    end
  end

  describe '#win_rate' do
    context 'when user1 has wins' do
      it 'returns the correct win rate' do
        expect(user1.win_rate).to eq(50.0)
      end
    end

    context 'when user has no wins' do
      let(:user3) { create(:user) }

      it 'returns 0' do
        expect(user3.win_rate).to eq(0)
      end
    end
  end

  describe '#total_games' do
    it 'returns the correct total number of finished games' do
      expect(user1.total_games).to eq(2)
    end
  end

  def create_game_with_result(user1, user2, winner)
    game = Game.create!(name: "Game #{Game.count + 1}", required_player_count: 2)
    game.users << [user1, user2]
    game.start!
    return unless winner

    game.go_fish.winner = game.go_fish.players.find { |player| player.user_id == winner.id }
    game.save!
  end
end
