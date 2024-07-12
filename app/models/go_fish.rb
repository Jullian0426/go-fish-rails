require_relative 'deck'

class GoFish
  STARTING_HAND_SIZE = 5

  attr_accessor :deck, :current_player, :players, :stay_turn, :winner, :round_results

  def initialize(players:, deck: Deck.new, current_player: players.first, winner: nil, round_results: [])
    @players = players
    @deck = deck
    @current_player = current_player
    @stay_turn = false
    @winner = winner
    @round_results = round_results
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
    if opponent.hand_has_rank?(rank)
      take_cards(opponent, rank)
    else
      go_fish(rank)
    end
    finalize_turn
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
    winner = payload['winner']
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
    drawn_card = deck.deal
    current_player.add_to_hand([drawn_card])
    self.stay_turn = drawn_card.rank == rank
  end

  def finalize_turn
    create_book_if_possible(current_player)
    round_results << RoundResult.new('test')
    next_player unless stay_turn
    game_over
    # TODO: deal cards to players with empty hands
  end

  def create_book_if_possible(player)
    ranks = player.hand.map(&:rank)
    book_rank = ranks.find { |rank| ranks.count(rank) == 4 }
    return unless book_rank

    book_cards = player.remove_by_rank(book_rank)
    new_book = Book.new(book_cards)
    player.books << new_book
  end

  def game_over
    return unless deck.cards.empty? && players.all? { |player| player.hand.empty? }

    self.winner = players.max_by { |player| player.books.size }.user_id
  end
end
