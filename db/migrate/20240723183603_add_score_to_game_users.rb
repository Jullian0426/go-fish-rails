class AddScoreToGameUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :game_users, :score, :integer
  end
end
