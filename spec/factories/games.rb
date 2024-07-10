FactoryBot.define do
  factory :game do
    sequence(:name) { |n| "Game #{n}" }
    required_player_count { 2 }
  end
end