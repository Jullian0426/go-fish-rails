class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
    @leaderboard = Leaderboard.all
  end

  def status
  end
end
