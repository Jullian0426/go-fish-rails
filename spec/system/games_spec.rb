require 'rails_helper'

RSpec.describe 'Games', type: :system, js: true do
  include Warden::Test::Helpers

  let(:user) { create(:user) }
  let!(:game1) { create(:game, name: 'Game 1') }
  let!(:game2) { create(:game, name: 'Game 2') }

  before do
    login_as(user, scope: :user)
    visit games_path
  end

  describe 'index page' do
    it 'shows all games and allows creating a new game' do
      expect(page).to have_content('All Games')
      expect(page).to have_link(game1.name, href: game_path(game1))
      expect(page).to have_link(game2.name, href: game_path(game2))
      expect(page).to have_link('Create New Game', href: new_game_path)

      click_link 'Create New Game'
      expect(page).to have_content('New Game')

      fill_in 'Name', with: 'New Game'
      click_button 'Create Game'

      expect(page).to have_content('New Game')
    end
  end

  describe 'creating a game' do
    it 'allows creating a new game' do
      visit new_game_path

      fill_in 'Name', with: 'Newly Created Game'
      click_button 'Create Game'

      expect(page).to have_content('Newly Created Game')
    end
  end

  describe 'show page' do
    it 'shows game details' do
      visit game_path(game1)

      expect(page).to have_content('Game Details')
      expect(page).to have_content("Game Name: #{game1.name}")
      expect(page).to have_content("Game ID: #{game1.id}")
      expect(page).to have_content('Edit')
      expect(page).to have_content('Delete')
    end
  end

  describe 'editing a game' do
    it 'allows editing an existing game' do
      visit edit_game_path(game1)

      fill_in 'Name', with: "Edited #{game1.name}"
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
