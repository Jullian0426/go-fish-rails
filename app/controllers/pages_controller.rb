class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
    @users = User.includes(:game_users, :games).all.sort do |a, b|
      [b.win_rate, b.wins] <=> [a.win_rate, a.wins]
    end
  end

  def status
  end
end
