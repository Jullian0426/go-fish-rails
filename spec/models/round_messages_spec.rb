require 'rails_helper'

RSpec.describe RoundMessages, type: :model do
  let(:current_player_name) { 'Player 1' }
  let(:opponent_name) { 'Player 2' }
  let(:rank) { 'King' }
  let(:card_drawn) { 'Queen of Hearts' }
  let(:book_rank) { 'Ace' }
  let(:round_state) do
    {
      current_player_name:,
      opponent_name:,
      rank:,
      card_drawn:,
      book_rank: nil
    }
  end

  let(:round_messages) { RoundMessages.new(round_state) }

  describe '#generate_player_messages' do
    it 'generates the correct player messages when drawing a card' do
      action = "You asked #{opponent_name} for #{rank}s"
      response = "Go Fish: #{opponent_name} doesn't have any #{rank}s"
      feedback = "You drew a #{card_drawn}"

      messages = round_messages.generate_player_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct player messages when taking cards' do
      round_state[:card_drawn] = nil
      action = "You asked #{opponent_name} for #{rank}s"
      response = "#{opponent_name} had the #{rank}s"
      feedback = "You took the cards from #{opponent_name}"

      messages = round_messages.generate_player_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct player messages when making a book' do
      round_state[:book_rank] = book_rank
      action = "You asked #{opponent_name} for #{rank}s"
      response = "Go Fish: #{opponent_name} doesn't have any #{rank}s"
      feedback = "You drew a #{card_drawn}"
      book = "You made a book of #{book_rank}s"

      messages = round_messages.generate_player_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to eq(book)
    end
  end

  describe '#generate_opponent_messages' do
    it 'generates the correct opponent messages when drawing a card' do
      action = "#{current_player_name} asked you for #{rank}s"
      response = "Go Fish: You don't have any #{rank}s"
      feedback = "#{current_player_name} drew a #{card_drawn}"

      messages = round_messages.generate_opponent_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct opponent messages when taking cards' do
      round_state[:card_drawn] = nil
      action = "#{current_player_name} asked you for #{rank}s"
      response = "You had the #{rank}s"
      feedback = "#{current_player_name} took the cards from you."

      messages = round_messages.generate_opponent_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct opponent messages when making a book' do
      round_state[:book_rank] = book_rank
      action = "#{current_player_name} asked you for #{rank}s"
      response = "Go Fish: You don't have any #{rank}s"
      feedback = "#{current_player_name} drew a #{card_drawn}"
      book = "#{current_player_name} made a book of #{book_rank}s"

      messages = round_messages.generate_opponent_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to eq(book)
    end
  end

  describe '#generate_others_messages' do
    it 'generates the correct others messages when drawing a card' do
      action = "#{current_player_name} asked #{opponent_name} for #{rank}s"
      response = "Go Fish: #{opponent_name} doesn't have any #{rank}s"
      feedback = "#{current_player_name} drew a #{card_drawn}"

      messages = round_messages.generate_others_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct others messages when taking cards' do
      round_state[:card_drawn] = nil
      action = "#{current_player_name} asked #{opponent_name} for #{rank}s"
      response = "#{opponent_name} had the #{rank}s"
      feedback = "#{current_player_name} took the cards from #{opponent_name}"

      messages = round_messages.generate_others_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to be_nil
    end

    it 'generates the correct others messages when making a book' do
      round_state[:book_rank] = book_rank
      action = "#{current_player_name} asked #{opponent_name} for #{rank}s"
      response = "Go Fish: #{opponent_name} doesn't have any #{rank}s"
      feedback = "#{current_player_name} drew a #{card_drawn}"
      book = "#{current_player_name} made a book of #{book_rank}s"

      messages = round_messages.generate_others_messages

      expect(messages[:action]).to eq(action)
      expect(messages[:response]).to eq(response)
      expect(messages[:feedback]).to eq(feedback)
      expect(messages[:book]).to eq(book)
    end
  end
end
