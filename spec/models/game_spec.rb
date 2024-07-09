require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { create(:game) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it 'has many users through game_users' do
    game.users << user1
    game.users << user2
    expect(game.users).to include(user1, user2)
  end
end
