class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
    @users = User.all.sort_by { |user| [-user.win_rate, -user.wins] }
  end

  def status
  end
end
