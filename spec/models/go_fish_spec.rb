require 'rails_helper'

RSpec.describe GoFish, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:player1) { Player.new(user_id: user1.id) }
  let(:player2) { Player.new(user_id: user2.id) }
  let(:players) { [player1, player2] }

  let(:go_fish) { GoFish.new(players:) }

  describe '#deal!' do
    it 'moves cards from deck to players' do
      go_fish.deal!

      expect(player1.hand.size).to eq(GoFish::STARTING_HAND_SIZE)
      expect(player2.hand.size).to eq(GoFish::STARTING_HAND_SIZE)
    end
  end

  describe 'play_round!' do
    let(:card1) { Card.new(rank: '3', suit: 'H') }
    let(:card2) { Card.new(rank: '6', suit: 'H') }
    let(:card3) { Card.new(rank: '6', suit: 'C') }
    let(:card4) { Card.new(rank: '10', suit: 'C') }
    let(:card5) { Card.new(rank: '3', suit: 'D') }
    let(:card6) { Card.new(rank: '3', suit: 'C') }
    let(:card7) { Card.new(rank: '3', suit: 'S') }

    before do
      player1.hand = [card1, card2]
      player2.hand = [card3, card4]
    end

    context '#take_cards' do
      it 'should take card from opponent and not change current player' do
        go_fish.play_round!(player2, '6')
        expect(player1.hand).to include(card3)
        expect(player2.hand).not_to include(card3)
        expect(go_fish.current_player).to eq(player1)
      end
    end

    context '#go_fish' do
      it 'updates current player when fished card is not requested rank' do
        go_fish.deck.cards = [card4]
        go_fish.play_round!(player2, '3')
        expect(player1.hand).to include(card4)
        expect(go_fish.current_player).to eq(player2)
      end

      it 'does not update current player when fished card is requested rank' do
        go_fish.deck.cards = [card5]
        go_fish.play_round!(player2, '3')
        expect(player1.hand).to include(card5)
        expect(go_fish.current_player).to eq(player1)
      end
    end

    context '#finalize_turn' do
      it 'creates a book if possible' do
        player1.add_to_hand([card5, card6])
        go_fish.deck.cards = [card7]
        go_fish.play_round!(player2, '3')
        expect(player1.hand).not_to include(card1, card5, card6, card7)
        expect(player1.books.first.cards).to include(card1, card5, card6, card7)
      end

      it 'does not create book if not possible' do
        player1.add_to_hand([card5])
        go_fish.deck.cards = [card7]
        go_fish.play_round!(player2, '3')
        expect(player1.hand).to include(card1, card5, card7)
      end

      it 'saves round result data' do
        expect(go_fish.round_result).to be_empty
        go_fish.play_round!(player2, '3')
        expect(go_fish.round_result).not_to be_empty
      end

      it 'sets the winner when a go_fish is over' do
        player1.hand = [card1, card5, card6]
        player2.hand = [card7]
        go_fish.deck.cards.clear
        go_fish.play_round!(player2, '3')
        expect(go_fish.winner).to eq(player1.user_id)
      end
    end
  end

  describe 'serialization' do
    context '#dump' do
      it 'dumps GoFish data as json' do
        dump = GoFish.dump(go_fish)
        expect(dump).not_to be(Hash)
      end
    end

    before do
      go_fish.deal!
      go_fish.play_round!(player2, player1.hand.first.rank)
    end

    context '#load' do
      it 'loads GoFish object from json' do
        json_payload = GoFish.dump(go_fish)
        loaded_go_fish = GoFish.load(json_payload)

        expect(loaded_go_fish).not_to be_nil
        expect(loaded_go_fish.players.map(&:user_id)).to match_array(go_fish.players.map(&:user_id))
        expect(loaded_go_fish.deck.cards).to match_array(go_fish.deck.cards)
        expect(loaded_go_fish.current_player.user_id).to eq(go_fish.current_player.user_id)
        expect(loaded_go_fish.round_result.last.messages['player']['action']).to match(go_fish.round_result.last.messages['player']['action'])
      end
    end
  end
end
