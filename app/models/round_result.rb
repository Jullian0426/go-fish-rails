# frozen_string_literal: true

class RoundResult
  attr_accessor :current_player, :opponent, :rank, :card_drawn, :book_rank, :messages

  def initialize(current_player:, opponent:, rank:, card_drawn:, book_rank:)
    @current_player = current_player
    @opponent = opponent
    @rank = rank
    @card_drawn = card_drawn
    @book_rank = book_rank
  end

  def self.from_json(round_result_data)
    current_player = Player.from_json(round_result_data['current_player'])
    opponent = Player.from_json(round_result_data['opponent'])
    rank = round_result_data['rank']
    book_rank = round_result_data['book_rank']
    card_drawn = Card.from_json(round_result_data['card_drawn']) unless round_result_data['card_drawn'].nil?
    RoundResult.new(current_player:, opponent:, rank:, card_drawn:, book_rank:)
  end

  # TODO: messages.send("#{context}_messages")
  def messages_for(context)
    round_message = RoundMessage.new(current_player:, opponent:, rank:, card_drawn:, book_rank:)

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
