# frozen_string_literal: true

class RoundResult
  attr_accessor :current_player, :opponent, :rank, :card_drawn, :book_rank, :winner, :messages

  # TODO: make id and update tests accordingly
  def initialize(current_player:, opponent:, rank:, card_drawn:, book_rank:, winner:)
    @current_player = current_player
    @opponent = opponent
    @rank = rank
    @card_drawn = card_drawn
    @book_rank = book_rank
    @winner = winner
  end

  def self.from_json(round_result_data)
    current_player = Player.from_json(round_result_data['current_player'])
    winner = Player.from_json(round_result_data['winner']) unless round_result_data['winner'].nil?
    opponent = Player.from_json(round_result_data['opponent'])
    rank = round_result_data['rank']
    book_rank = round_result_data['book_rank']
    card_drawn = Card.from_json(round_result_data['card_drawn']) unless round_result_data['card_drawn'].nil?
    RoundResult.new(current_player:, opponent:, rank:, card_drawn:, book_rank:, winner:)
  end

  # TODO: messages.send("#{context}_messages")
  def messages_for(context)
    round_message = RoundMessage.new(current_player:, opponent:, rank:, card_drawn:, book_rank:, winner:)

    case context
    when :player
      round_message.generate_player_messages
    when :opponent
      round_message.generate_opponent_messages
    when :others
      round_message.generate_others_messages
    end
  end
end
