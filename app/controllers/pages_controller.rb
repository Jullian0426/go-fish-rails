class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
    @users = User.includes(:game_users, :games).all.sort do |a, b|
      [b.total_score, b.win_rate] <=> [a.total_score, a.win_rate]
    end
  end

  def status
  end
end
