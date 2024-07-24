class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
    @q = Leaderboard.ransack(params[:q])
    page = (params[:page].presence || 1).to_i
    @leaderboards = @q.result.order(score: :desc).page(page)

    @ranked_leaderboards = @leaderboards.each_with_index.map do |leaderboard, index|
      leaderboard.rank = ((page - 1) * @leaderboards.limit_value) + index + 1
      leaderboard
    end
  end

  def status
  end
end
