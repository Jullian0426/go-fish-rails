def play_random_rounds(game)
  play_to_completion = [true, false].sample
  number_of_rounds = play_to_completion ? 1000 : rand(5..15)

  number_of_rounds.times do
    break if game.go_fish.winner

    current_player = game.go_fish.current_player
    opponents = game.go_fish.players.reject { |player| player.user_id == current_player.user_id }
    opponent_id = opponents.sample.user_id
    rank = current_player.hand.sample.rank

    game.play_round!(opponent_id, rank)
  end
end

namespace :db do
  desc 'Seed the database with users and games'
  task seed: :environment do
    # Create 100 users
    100.times do |i|
      User.create!(
        email: "user#{i + 1}@example.com",
        password: 'password',
        password_confirmation: 'password'
      )
    end

    user_count = User.count

    # Create games and play random number of rounds
    100.times do |i|
      num_users = (2..5).to_a.sample
      offset = rand(user_count - num_users)
      users = User.offset(offset).limit(num_users)
      game = Game.create!(name: "Game #{i + 1}", required_player_count: users.count)
      game.users << users
      game.start!

      play_random_rounds(game)
    end

    puts 'Seeding completed successfully.'
  end
end
