# frozen_string_literal: true

# TODO: look into using a data object
class RoundMessage
  attr_accessor :current_player, :opponent, :rank, :card_drawn, :book_rank

  def initialize(current_player:, opponent:, rank:, card_drawn:, book_rank:)
    @current_player = current_player
    @opponent = opponent
    @rank = rank
    @card_drawn = card_drawn
    @book_rank = book_rank
  end

  def generate_player_messages
    {
      action: player_action_message,
      response: player_response_message,
      feedback: player_feedback_message,
      book: book_message(true)
    }.with_indifferent_access
  end

  def generate_opponent_messages
    {
      action: opponent_action_message,
      response: opponent_response_message,
      feedback: opponent_feedback_message,
      book: book_message(false)
    }.with_indifferent_access
  end

  def generate_others_messages
    {
      action: others_action_message,
      response: others_response_message,
      feedback: others_feedback_message,
      book: book_message(false)
    }.with_indifferent_access
  end

  private

  def player_action_message
    "You asked #{opponent.name} for #{rank}s"
  end

  def player_response_message
    if card_drawn.nil?
      "#{opponent.name} had the #{rank}s"
    else
      "Go Fish: #{opponent.name} doesn't have any #{rank}s"
    end
  end

  def player_feedback_message
    if card_drawn
      "You drew a #{card_drawn.rank} of #{card_drawn.suit}"
    else
      "You took the cards from #{opponent.name}"
    end
  end

  def opponent_action_message
    "#{current_player.name} asked you for #{rank}s"
  end

  def opponent_response_message
    if card_drawn.nil?
      "You had the #{rank}s"
    else
      "Go Fish: You don't have any #{rank}s"
    end
  end

  def opponent_feedback_message
    if card_drawn
      "#{current_player.name} drew a card"
    else
      "#{current_player.name} took the cards from you"
    end
  end

  def others_action_message
    "#{current_player.name} asked #{opponent.name} for #{rank}s"
  end

  def others_response_message
    if card_drawn.nil?
      "#{opponent.name} had the #{rank}s"
    else
      "Go Fish: #{opponent.name} doesn't have any #{rank}s"
    end
  end

  def others_feedback_message
    if card_drawn
      "#{current_player.name} drew a card"
    else
      "#{current_player.name} took the cards from #{opponent.name}"
    end
  end

  def book_message(for_player)
    return nil unless book_rank

    name = if for_player
             'You'
           else
             current_player.name
           end

    "#{name} made a book of #{book_rank}s"
  end
end
