require 'rails_helper'

RSpec.describe RoundResult, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:current_player) { Player.new(user_id: user1.id) }
  let(:opponent) { Player.new(user_id: user2.id) }
  let(:rank) { 'King' }
  let(:card_drawn) { Card.new(rank: 'Queen', suit: 'Hearts') }
  let(:book_rank) { 'Ace' }

  describe '#generate_messages' do
    it 'generates correct messages' do
      round_result = RoundResult.new(current_player:, opponent:, rank:, card_drawn:, book_rank:)
      round_message = RoundMessage.new(current_player:, opponent:, rank:, card_drawn:, book_rank:)

      expect(round_result.messages_for(:player)).to eq(round_message.generate_player_messages)
      expect(round_result.messages_for(:opponent)).to eq(round_message.generate_opponent_messages)
      expect(round_result.messages_for(:others)).to eq(round_message.generate_others_messages)
    end
  end
end
