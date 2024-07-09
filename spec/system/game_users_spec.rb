require 'rails_helper'

RSpec.describe 'GameUsers', type: :system, js: true do
  include Warden::Test::Helpers

  let(:user) { create(:user) }
  let!(:game) { create(:game, name: 'Test Game') }

  before do
    login_as(user, scope: :user)
    visit games_path
  end

  it 'allows a user to join a game' do
    expect(page).to have_button('Join Game')
    click_button 'Join Game'
    expect(page).to have_content('You have joined the game.')
    expect(game.users).to include(user)
  end
end