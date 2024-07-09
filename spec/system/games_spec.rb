require 'rails_helper'

RSpec.describe 'Games', type: :system, js: true do
  include Warden::Test::Helpers

  let(:user) { create(:user) }
  let!(:game1) { create(:game, name: 'Game 1', required_player_count: 4) }
  let!(:game2) { create(:game, name: 'Game 2', required_player_count: 4) }

  def join_game
    within 'li', text: game1.name do
      click_button 'Join Game'
    end
  end

  before do
    login_as(user, scope: :user)
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

      join_game

      visit games_path
      expect(page).to have_link(game1.name, href: game_path(game1))
      expect(page).to have_content("1/#{game1.required_player_count} Players")
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

  describe 'show page' do
    it 'shows game details and users' do
      join_game

      expect(page).to have_content('Game Details')
      expect(page).to have_content("Game Name: #{game1.name}")
      expect(page).to have_content('Edit')
      expect(page).to have_content('Delete')
      expect(page).to have_content('Users in this game')
      expect(page).to have_content(user.name)
      expect(page).to have_content("1/#{game1.required_player_count} Players")
    end
  end

  describe 'editing a game' do
    it 'allows editing an existing game' do
      visit edit_game_path(game1)

      find_field('Name').set("Edited #{game1.name}")
      click_button 'Update Game'

      expect(page).to have_content("Game Name: Edited #{game1.name}")
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