require 'rails_helper'

RSpec.describe RoundMessage, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:current_player) { Player.new(user_id: user1.id) }
  let(:opponent) { Player.new(user_id: user2.id) }
  let(:third_player) { Player.new(user_id: user3.id) }
  let(:rank) { 'King' }
  let(:card_drawn) { Card.new(rank: 'Queen', suit: 'Hearts') }
  let(:book_rank) { 'Ace' }
  let(:winners) { [current_player] }

  let(:round_message) do
    RoundMessage.new(current_player:, opponent:, rank:, card_drawn:, book_rank:, winners:)
  end

  def expect_messages(messages, action:, response:, feedback:, book:, game_over:)
    expect(messages[:action]).to eq(action)
    expect(messages[:response]).to eq(response)
    expect(messages[:feedback]).to eq(feedback)
    expect(messages[:book]).to eq(book)
    expect(messages[:game_over]).to eq(game_over)
  end

  describe '#generate_player_messages' do
    it 'generates the correct player messages when drawing a card' do
      round_message.book_rank = nil
      round_message.winners = []
      messages = round_message.generate_player_messages

      expect_messages(messages, action: "You asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "You drew a #{card_drawn.rank} of #{card_drawn.suit}",
                                book: nil,
                                game_over: nil)
    end

    it 'generates the correct player messages when taking cards' do
      round_message.card_drawn = nil
      round_message.book_rank = nil
      round_message.winners = []
      messages = round_message.generate_player_messages

      expect_messages(messages, action: "You asked #{opponent.name} for #{rank}s",
                                response: "#{opponent.name} had the #{rank}s",
                                feedback: "You took the cards from #{opponent.name}",
                                book: nil,
                                game_over: nil)
    end

    it 'generates the correct player messages when making a book' do
      round_message.winners = []
      messages = round_message.generate_player_messages

      expect_messages(messages, action: "You asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "You drew a #{card_drawn.rank} of #{card_drawn.suit}",
                                book: "You made a book of #{book_rank}s",
                                game_over: nil)
    end

    it 'generates the correct player messages when the game is over' do
      messages = round_message.generate_player_messages

      expect_messages(messages, action: "You asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "You drew a #{card_drawn.rank} of #{card_drawn.suit}",
                                book: "You made a book of #{book_rank}s",
                                game_over: 'You won the game!')
    end

    it 'generates the correct player messages when there are multiple winners' do
      round_message.winners = [current_player, opponent]
      messages = round_message.generate_player_messages

      expect_messages(messages, action: "You asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "You drew a #{card_drawn.rank} of #{card_drawn.suit}",
                                book: "You made a book of #{book_rank}s",
                                game_over: "You and #{opponent.name} won the game!")
    end
  end

  describe '#generate_opponent_messages' do
    it 'generates the correct opponent messages when drawing a card' do
      round_message.book_rank = nil
      round_message.winners = []
      messages = round_message.generate_opponent_messages

      expect_messages(messages, action: "#{current_player.name} asked you for #{rank}s",
                                response: "Go Fish: You don't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: nil,
                                game_over: nil)
    end

    it 'generates the correct opponent messages when taking cards' do
      round_message.card_drawn = nil
      round_message.book_rank = nil
      round_message.winners = []
      messages = round_message.generate_opponent_messages

      expect_messages(messages, action: "#{current_player.name} asked you for #{rank}s",
                                response: "You had the #{rank}s",
                                feedback: "#{current_player.name} took the cards from you",
                                book: nil,
                                game_over: nil)
    end

    it 'generates the correct opponent messages when making a book' do
      round_message.winners = []
      messages = round_message.generate_opponent_messages

      expect_messages(messages, action: "#{current_player.name} asked you for #{rank}s",
                                response: "Go Fish: You don't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: "#{current_player.name} made a book of #{book_rank}s",
                                game_over: nil)
    end

    it 'generates the correct opponent messages when the game is over' do
      messages = round_message.generate_opponent_messages

      expect_messages(messages, action: "#{current_player.name} asked you for #{rank}s",
                                response: "Go Fish: You don't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: "#{current_player.name} made a book of #{book_rank}s",
                                game_over: "#{current_player.name} won the game!")
    end

    it 'generates the correct opponent messages when there are multiple winners' do
      round_message.winners = [current_player, opponent]
      messages = round_message.generate_opponent_messages

      expect_messages(messages, action: "#{current_player.name} asked you for #{rank}s",
                                response: "Go Fish: You don't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: "#{current_player.name} made a book of #{book_rank}s",
                                game_over: "#{current_player.name} and #{opponent.name} won the game!")
    end
  end

  describe '#generate_others_messages' do
    it 'generates the correct others messages when drawing a card' do
      round_message.book_rank = nil
      round_message.winners = []
      messages = round_message.generate_others_messages

      expect_messages(messages, action: "#{current_player.name} asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: nil,
                                game_over: nil)
    end

    it 'generates the correct others messages when taking cards' do
      round_message.card_drawn = nil
      round_message.book_rank = nil
      round_message.winners = []
      messages = round_message.generate_others_messages

      expect_messages(messages, action: "#{current_player.name} asked #{opponent.name} for #{rank}s",
                                response: "#{opponent.name} had the #{rank}s",
                                feedback: "#{current_player.name} took the cards from #{opponent.name}",
                                book: nil,
                                game_over: nil)
    end

    it 'generates the correct others messages when making a book' do
      round_message.winners = []
      messages = round_message.generate_others_messages

      expect_messages(messages, action: "#{current_player.name} asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: "#{current_player.name} made a book of #{book_rank}s",
                                game_over: nil)
    end

    it 'generates the correct others messages when the game is over' do
      messages = round_message.generate_others_messages

      expect_messages(messages, action: "#{current_player.name} asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: "#{current_player.name} made a book of #{book_rank}s",
                                game_over: "#{current_player.name} won the game!")
    end

    it 'generates the correct others messages when there are multiple winners' do
      round_message.winners = [current_player, opponent, third_player]
      messages = round_message.generate_others_messages

      expect_messages(messages, action: "#{current_player.name} asked #{opponent.name} for #{rank}s",
                                response: "Go Fish: #{opponent.name} doesn't have any #{rank}s",
                                feedback: "#{current_player.name} drew a card",
                                book: "#{current_player.name} made a book of #{book_rank}s",
                                game_over: "#{current_player.name}, #{opponent.name}, and #{third_player.name} won the game!")
    end
  end
end
