require 'rails_helper'

RSpec.describe 'Games', type: :system, js: true do
  include Warden::Test::Helpers

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:game1) { create(:game, name: 'Game 1', required_player_count: 2) }
  let!(:game2) { create(:game, name: 'Game 2', required_player_count: 4) }

  def join_game(game)
    within('.game-row', text: game.name) do
      click_button 'Join Game'
    end
  end

  def take_turn(game)
    select user2.name, from: 'opponent_id'
    click_button game.go_fish.current_player.hand.first.rank.to_s
    click_button 'Ask for Cards'
  end

  before do
    login_as(user1, scope: :user)
    visit games_path
  end

  describe 'index page' do
    it 'shows all games' do
      expect(page).to have_content('All Games')
      expect(page).to have_content('Your Games')
      expect(page).to have_link('New Game', href: new_game_path)
      expect(page).to have_content(game1.name)
      expect(page).to have_content(game2.name)
      expect(page).to have_content("0/#{game1.required_player_count} Players")
      expect(page).to have_content("0/#{game2.required_player_count} Players")
    end

    it 'shows your games' do
      expect(page).to have_content('You have no active games.')
      expect(page).not_to have_link(game1.name, href: game_path(game1))
    end
  end

  describe 'creating a game' do
    it 'allows creating a new game' do
      expect(page).to have_content('All Games')
      click_on 'New Game'

      fill_in 'Name', with: 'Newly Created Game'
      fill_in 'Required player count', with: 4
      expect(page).to have_content('All Games')
      click_button 'Create Game'

      expect(page).to have_content('Newly Created Game')
      expect(page).to have_content('0/4 Players')
    end
  end

  describe 'showing a game' do
    context 'when game has not started' do
      before do
        join_game(game2)
        game2.reload
      end

      it 'shows waiting message and current game details' do
        expect(page).to have_content(game1.name)
        expect(page).to have_content('Waiting for Players...')
        expect(page).to have_content(user1.name)
        expect(page).to have_content("1/#{game2.required_player_count} Players")
      end

      it 'broadcasts when another player joins the game' do
        expect(page).to have_content("1/#{game2.required_player_count} Players")
        game2.users << user2
        game2.save!

        expect(page).to have_content("2/#{game2.reload.required_player_count} Players")
      end
    end

    context 'when game has started' do
      it 'broadcasts a started game to waiting users' do
        join_game(game1)
        expect(page).to have_content("1/#{game1.reload.required_player_count} Players")

        game1.users << user2
        game1.start!

        expect(page).to have_selector("input[type=submit][value='Ask for Cards']")
      end

      context 'after users are updated' do
        before do
          join_game(game1)
          game1.users << user2
          game1.start!
          game1.reload
        end

        it 'displays current player' do
          expect(page).to have_content("#{game1.go_fish.current_player.name}'s Turn")
        end

        it "displays user1's hand" do
          game1.go_fish.current_player.hand.each do |card|
            expect(page).to have_selector("img[alt='#{card.rank} of #{card.suit}']")
          end
        end

        it "does not display user2's hand" do
          other_player = game1.go_fish.players.find { |player| player.user_id == user2.id }
          other_player.hand.each do |card|
            expect(page).not_to have_selector("img[alt='#{card.rank} of #{card.suit}']")
          end
        end

        it 'displays turn form only for the current player' do
          expect(page).to have_selector("input[type=submit][value='Ask for Cards']")
          logout
          login_as(user2, scope: :user)
          visit game_path(game1)
          expect(page).to have_selector("input[type=submit][value='Ask for Cards'][disabled]")
        end

        context 'when playing a round' do
          it 'runs play_round! when Ask for Cards button is pressed' do
            expect_any_instance_of(Game).to receive(:play_round!).with(user2.id,
                                                                       game1.go_fish.current_player.hand.first.rank)

            expect(page).to have_selector("input[type=submit][value='Ask for Cards']")
            take_turn(game1)
          end

          # TODO: fix this test
          xit 'broadcasts when another user takes their turn' do
            expect(page).to have_content("#{user1.name}'s Turn")
            take_turn(game1)
            expect(page).to have_content("#{user2.name}'s Turn")
            game1.play_round!(user1.name, game1.go_fish.current_player.hand.first.rank)
            expect(page).to have_content("#{user1.name}'s Turn")
          end

          it "increases number of cards in user1's hand" do
            take_turn(game1)
            expect(page).to have_content('You asked')
            expect(game1.reload.go_fish.players.first.hand.size).to be > GoFish::STARTING_HAND_SIZE
          end

          it 'displays round result message' do
            expect(page).not_to have_selector('div.notification--action')
            take_turn(game1)

            game1.reload
            expect(page).to have_selector('div.notification--action')
          end
        end

        context 'when a game is over' do
          let(:card1) { Card.new(rank: '3', suit: 'Hearts') }
          let(:card2) { Card.new(rank: '3', suit: 'Diamonds') }
          let(:card3) { Card.new(rank: '3', suit: 'Clubs') }
          let(:card4) { Card.new(rank: '3', suit: 'Spades') }

          before do
            game1.go_fish.deck.cards.clear
            game1.go_fish.players.each { |player| player.hand.clear }
            game1.go_fish.players.first.add_to_hand([card1, card2, card3])
            game1.go_fish.players.last.add_to_hand([card4])
            game1.save!
            game1.reload
          end

          it 'tells the user if they have won' do
            take_turn(game1)
            expect(page).to have_content('You won the game!')
          end

          it 'tells the user if another player has won' do
            take_turn(game1)
            expect(page).not_to have_content("#{user1.name} won the game!")
            logout
            login_as(user2, scope: :user)
            visit game_path(game1)
            expect(page).to have_content("#{user1.name} won the game!")
          end

          it 'replaces the Ask for Cards button with a Leave Game button' do
            take_turn(game1)
            expect(page).to have_content('Leave Game')
            logout
            login_as(user2, scope: :user)
            visit game_path(game1)
            expect(page).to have_content('Leave Game')
          end

          # TODO: move out of system tests
          xit "doesn't allow a user to take a turn" do
            take_turn(game1)
            expect(page).to have_content('You won the game!')
            game1.reload
            game1.play_round!(user1.name, '3')
            expect(page).to have_content('Error: Invalid Turn')
          end
        end
      end
    end
  end

  describe 'editing a game' do
    before do
      visit games_path
      join_game(game1)
      click_on 'arrow_back'
    end

    xit 'allows editing an existing game' do
      click_link 'Edit', match: :first

      find_field('Name').set("Edited #{game1.name}")
      click_button 'Update Game'

      expect(page).to have_content("Edited #{game1.name}")
    end
  end

  describe 'deleting a game' do
    before do
      visit games_path
      join_game(game1)
      visit games_path
    end

    xit 'allows deleting an existing game' do
      click_button 'Delete', match: :first

      expect(page).to have_no_content(game1.name)
    end
  end
end
