require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:game) { create(:game) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  before do
    create(:game_user, game:, user: user1)
    create(:game_user, game:, user: user2)
  end

  # TODO: test return block and middle of method
  describe '#start!' do
    it 'updates go_fish attribute' do
      expect(game.go_fish).to be_nil

      game.start!

      expect(game.go_fish).not_to be_nil
    end
  end
end
