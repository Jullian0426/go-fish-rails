class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
  end

  def status
  end
end