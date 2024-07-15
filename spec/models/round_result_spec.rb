require 'rails_helper'

RSpec.describe RoundResult, type: :model do
  let(:current_player_name) { 'Player 1' }
  let(:opponent_name) { 'Player 2' }
  let(:rank) { 'King' }
  let(:card_drawn) { Card.new(rank: 'Queen', suit: 'Hearts') }
  let(:book_rank) { 'Ace' }

  describe '#generate_messages' do
    it 'generates correct messages' do
      round_result = RoundResult.new(current_player_name:, opponent_name:, rank:, card_drawn:, book_rank:)
      round_messages = RoundMessages.new(current_player_name:, opponent_name:, rank:, card_drawn:, book_rank:)

      expect(round_result.messages[:player]).to eq(round_messages.generate_player_messages)
      expect(round_result.messages[:opponent]).to eq(round_messages.generate_opponent_messages)
      expect(round_result.messages[:others]).to eq(round_messages.generate_others_messages)
    end
  end
end
