require 'rails_helper'

RSpec.describe GameUser, type: :model do
  let(:game) { create(:game) }
  let(:user) { create(:user) }

  it 'enforces database uniqueness constraint' do
    create(:game_user, game:, user:)
    expect do
      GameUser.create!(game:, user:)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
