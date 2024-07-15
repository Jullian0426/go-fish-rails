# frozen_string_literal: true

class RoundResult
  MESSAGES = {
    player: {},
    opponent: {},
    others: {}
  }.with_indifferent_access.freeze

  attr_accessor :current_player_name, :opponent_name, :rank, :card_drawn, :book_rank, :messages

  def initialize(current_player_name:, opponent_name:, rank:, card_drawn:, book_rank:)
    @current_player_name = current_player_name
    @opponent_name = opponent_name
    @rank = rank
    @card_drawn = card_drawn
    @book_rank = book_rank
    @messages = MESSAGES.dup
    generate_messages
  end

  def self.from_json(round_result_data)
    current_player_name = round_result_data['current_player_name']
    opponent_name = round_result_data['opponent_name']
    rank = round_result_data['rank']
    book_rank = round_result_data['book_rank']
    card_drawn = Card.from_json(round_result_data['card_drawn'])
    RoundResult.new(current_player_name:, opponent_name:, rank:, card_drawn:, book_rank:)
  end

  private

  def generate_messages
    round_messages = RoundMessages.new(current_player_name:, opponent_name:, rank:, card_drawn:, book_rank:)

    messages['player'] = round_messages.generate_player_messages
    messages['opponent'] = round_messages.generate_opponent_messages
    messages['others'] = round_messages.generate_others_messages
  end
end
