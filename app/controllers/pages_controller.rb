class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
    @leaderboards = Leaderboard.all.page(params[:page])
  end

  def status
  end
end
