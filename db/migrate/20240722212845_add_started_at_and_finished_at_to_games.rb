class AddStartedAtAndFinishedAtToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :started_at, :datetime
    add_column :games, :finished_at, :datetime
  end
end
