require 'rails_helper'

RSpec.describe RoundMessage, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:current_player) { Player.new(user_id: user1.id) }
  let(:opponent) { Player.new(user_id: user2.id) }
  let(:rank) { 'King' }
  let(:card_drawn) { Card.new(rank: 'Queen', suit: 'Hearts') }
  let(:book_rank) { 'Ace' }

  let(:round_message) { RoundMessage.new(current_player:, opponent:, rank:, card_drawn:, book_rank:) }

  describe '#generate_player_messages' do
    it 'generates the correct player messages when drawing a card' do
      action = "You asked #{opponent.name} for #{rank}s"
      response = "Go Fish: #{opponent.name} doesn't have any #{rank}s"
      feedback = "You drew a #{card_drawn.rank} of #{card_drawn.suit}"

      round_message.book_rank = nil
      messages = round_message.generate_player_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct player messages when taking cards' do
      action = "You asked #{opponent.name} for #{rank}s"
      response = "#{opponent.name} had the #{rank}s"
      feedback = "You took the cards from #{opponent.name}"

      round_message.card_drawn = nil
      round_message.book_rank = nil
      messages = round_message.generate_player_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct player messages when making a book' do
      action = "You asked #{opponent.name} for #{rank}s"
      response = "Go Fish: #{opponent.name} doesn't have any #{rank}s"
      feedback = "You drew a #{card_drawn.rank} of #{card_drawn.suit}"
      book = "You made a book of #{book_rank}s"

      messages = round_message.generate_player_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to eq(book)
    end
  end

  describe '#generate_opponent_messages' do
    it 'generates the correct opponent messages when drawing a card' do
      action = "#{current_player.name} asked you for #{rank}s"
      response = "Go Fish: You don't have any #{rank}s"
      feedback = "#{current_player.name} drew a card"

      round_message.book_rank = nil
      messages = round_message.generate_opponent_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct opponent messages when taking cards' do
      action = "#{current_player.name} asked you for #{rank}s"
      response = "You had the #{rank}s"
      feedback = "#{current_player.name} took the cards from you"

      round_message.card_drawn = nil
      round_message.book_rank = nil
      messages = round_message.generate_opponent_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct opponent messages when making a book' do
      action = "#{current_player.name} asked you for #{rank}s"
      response = "Go Fish: You don't have any #{rank}s"
      feedback = "#{current_player.name} drew a card"
      book = "#{current_player.name} made a book of #{book_rank}s"

      messages = round_message.generate_opponent_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to eq(book)
    end
  end

  describe '#generate_others_messages' do
    it 'generates the correct others messages when drawing a card' do
      action = "#{current_player.name} asked #{opponent.name} for #{rank}s"
      response = "Go Fish: #{opponent.name} doesn't have any #{rank}s"
      feedback = "#{current_player.name} drew a card"

      round_message.book_rank = nil
      messages = round_message.generate_others_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct others messages when taking cards' do
      action = "#{current_player.name} asked #{opponent.name} for #{rank}s"
      response = "#{opponent.name} had the #{rank}s"
      feedback = "#{current_player.name} took the cards from #{opponent.name}"

      round_message.card_drawn = nil
      round_message.book_rank = nil
      messages = round_message.generate_others_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct others messages when making a book' do
      action = "#{current_player.name} asked #{opponent.name} for #{rank}s"
      response = "Go Fish: #{opponent.name} doesn't have any #{rank}s"
      feedback = "#{current_player.name} drew a card"
      book = "#{current_player.name} made a book of #{book_rank}s"

      messages = round_message.generate_others_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to eq(book)
    end
  end
end
