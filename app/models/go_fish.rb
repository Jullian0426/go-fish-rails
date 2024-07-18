require_relative 'deck'

class GoFish
  class InvalidRank < StandardError; end

  STARTING_HAND_SIZE = 5

  attr_accessor :deck, :current_player, :players, :stay_turn, :winner, :round_results, :card_drawn

  def initialize(players:, deck: Deck.new, current_player: players.first, winner: nil, round_results: [])
    @players = players
    @deck = deck
    @current_player = current_player
    @stay_turn = false
    @winner = winner
    @round_results = round_results
    @card_drawn = nil
  end

  def deal!
    deck.shuffle!

    STARTING_HAND_SIZE.times do
      players.each { |player| player.add_to_hand(deck.deal) }
    end
  end

  def next_player
    self.current_player = players[(players.index(current_player) + 1) % players.size]
  end

  def play_round!(opponent, rank)
    raise InvalidRank unless current_player.hand_has_rank?(rank)

    if opponent.hand_has_rank?(rank)
      take_cards(opponent, rank)
    else
      go_fish(rank)
    end
    finalize_turn(opponent, rank)
  end

  def self.dump(object)
    object.as_json
  end

  def self.load(payload)
    return if payload.nil?

    from_json(payload)
  end

  def self.from_json(payload)
    players = payload['players'].map { |player_data| Player.from_json(player_data) }
    deck = Deck.from_json(payload['deck'])
    current_player = players.detect { |player| player.user_id == payload['current_player']['user_id'] }
    winner = players.detect { |player| player.user_id == payload['winner']['user_id'] } unless payload['winner'].nil?
    round_results = payload['round_results']&.map { |round_result_data| RoundResult.from_json(round_result_data) }
    GoFish.new(players:, deck:, current_player:, winner:, round_results:)
  end

  private

  def take_cards(opponent, rank)
    cards_to_move = opponent.remove_by_rank(rank)
    current_player.add_to_hand(cards_to_move)
    self.stay_turn = true
  end

  def go_fish(rank)
    self.card_drawn = deck.deal
    current_player.add_to_hand([card_drawn])
    self.stay_turn = card_drawn.rank == rank
  end

  def finalize_turn(opponent, rank)
    book_rank = create_book_if_possible(current_player)
    game_over
    create_results(opponent, rank, book_rank)
    next_player unless stay_turn
    # TODO: deal cards to players with empty hands
  end

  def create_book_if_possible(player)
    ranks = player.hand.map(&:rank)
    book_rank = ranks.find { |rank| ranks.count(rank) == 4 }
    return nil unless book_rank

    book_cards = player.remove_by_rank(book_rank)
    new_book = Book.new(book_cards)
    player.books << new_book
    new_book.cards.first.rank
  end

  def create_results(opponent, rank, book_rank = nil)
    round_results << RoundResult.new(current_player:, opponent:, rank:, card_drawn:, book_rank:, winner:)
  end

  def game_over
    return unless deck.cards.empty? && players.all? { |player| player.hand.empty? }

    self.winner = players.max_by { |player| player.books.size }
  end
end
