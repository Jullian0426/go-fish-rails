require 'rails_helper'

RSpec.describe 'Games', type: :system, js: true do
  include Warden::Test::Helpers

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:game1) { create(:game, name: 'Game 1', required_player_count: 2) }
  let!(:game2) { create(:game, name: 'Game 2', required_player_count: 4) }

  def join_game
    within 'li', text: game1.name do
      click_button 'Join Game'
    end
  end

  before do
    login_as(user1, scope: :user)
    visit games_path
  end

  describe 'index page' do
    it 'shows all games' do
      expect(page).to have_content('All Games')
      expect(page).to have_content('Your Games')
      expect(page).to have_link('Create New Game', href: new_game_path)
      expect(page).to have_content(game1.name)
      expect(page).to have_content(game2.name)
      expect(page).to have_content("0/#{game1.required_player_count} Players")
      expect(page).to have_content("0/#{game2.required_player_count} Players")
    end

    it 'shows your games' do
      expect(page).to have_content('You have not joined any games yet.')
      expect(page).not_to have_link(game1.name, href: game_path(game1))
    end
  end

  describe 'creating a game' do
    it 'allows creating a new game' do
      visit new_game_path

      fill_in 'Name', with: 'Newly Created Game'
      fill_in 'Required player count', with: 4
      click_button 'Create Game'

      visit games_path
      expect(page).to have_content('Newly Created Game')
      expect(page).to have_content('0/4 Players')
    end
  end

  describe 'showing a game' do
    context 'when game has not started' do
      it 'shows waiting message and current game details' do
        join_game

        expect(page).to have_content(game1.name)
        expect(page).to have_content('Edit')
        expect(page).to have_content('Delete')
        expect(page).to have_content('Waiting for game to start...')
        expect(page).to have_content(user1.name)
        expect(page).to have_content("1/#{game1.required_player_count} Players")
      end
    end

    context 'when game has started' do
      before do
        join_game
        game1.users << user2
        game1.start!
        visit game_path(game1)
      end

      it 'displays current player' do
        expect(page).to have_content("Current Player: #{User.find(game1.go_fish.current_player.user_id).name}")
      end

      it "displays user1's hand" do
        game1.go_fish.current_player.hand.each do |card|
          expect(page).to have_content("#{card.rank} of #{card.suit}")
        end
      end

      it "does not display user2's hand" do
        other_player = game1.go_fish.players.find { |player| player.user_id == user2.id }
        other_player.hand.each do |card|
          expect(page).not_to have_content("#{card.rank} of #{card.suit}")
        end
      end

      it 'displays turn form only for the current player' do
        expect(page).to have_content('Take Turn')
        logout
        login_as(user2, scope: :user)
        visit game_path(game1)
        expect(page).not_to have_content('Take Turn')
      end
    end
  end

  describe 'editing a game' do
    xit 'allows editing an existing game' do
      visit edit_game_path(game1)

      find_field('Name').set("Edited #{game1.name}")
      click_button 'Update Game'

      expect(page).to have_content("Edited #{game1.name}")
    end
  end

  describe 'deleting a game' do
    it 'allows deleting an existing game' do
      visit game_path(game1)

      click_button 'Delete'

      expect(page).to have_no_content(game1.name)
    end
  end
end
