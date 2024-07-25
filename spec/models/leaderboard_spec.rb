require 'rails_helper'

RSpec.describe Leaderboard, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:game) { create(:game) }
  let(:card1) { Card.new(rank: 'King', suit: 'Hearts') }
  let(:card2) { Card.new(rank: 'King', suit: 'Diamonds') }
  let(:card3) { Card.new(rank: 'King', suit: 'Clubs') }
  let(:card4) { Card.new(rank: 'King', suit: 'Spades') }

  before do
    create(:game_user, game:, user: user1)
    create(:game_user, game:, user: user2)

    game.start!
    @player1 = game.go_fish.players.first
    @player2 = game.go_fish.players.last

    @player1.hand = [card1, card2, card3]
    @player2.hand = [card4]

    game.go_fish.deck.cards.clear
    game.play_round!(user2.id, 'King')
  end

  context 'Leaderboard attributes' do
    let(:leaderboard_user1) { Leaderboard.find(user1.id) }
    let(:leaderboard_user2) { Leaderboard.find(user2.id) }

    it 'returns the correct score for users' do
      expected_score = @player1.books.sum(&:value)
      expect(leaderboard_user1.score).to eq(expected_score)
      expect(leaderboard_user2.score).to eq(0)
    end

    it 'returns the correct wins for users' do
      expect(leaderboard_user1.wins).to eq(1)
      expect(leaderboard_user2.wins).to eq(0)
    end

    it 'returns the correct losses for users' do
      expect(leaderboard_user1.losses).to eq(0)
      expect(leaderboard_user2.losses).to eq(1)
    end

    it 'returns the correct games played for users' do
      expect(leaderboard_user1.games_played).to eq(1)
      expect(leaderboard_user2.games_played).to eq(1)
    end

    it 'returns the correct time played for users' do
      expected_time = game.finished_at - game.started_at
      expect(leaderboard_user1.seconds_played).to eq(expected_time)
      expect(leaderboard_user2.seconds_played).to eq(expected_time)
    end
  end
end
