class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def leaderboard
    @q = Leaderboard.ransack(params[:q])
    page = (params[:page].presence || 1).to_i
    @leaderboards = @q.result.page(page)

    sort_direction = determine_sort_direction
    @ranked_leaderboards = rank_leaderboards(@leaderboards, page, sort_direction)
  end

  def status
  end

  def history
  end

  private

  def determine_sort_direction
    @q.sorts.first&.dir || 'desc'
  end

  def rank_leaderboards(leaderboards, page, sort_direction)
    leaderboards.each_with_index.map do |leaderboard, index|
      leaderboard.rank = calculate_rank(index, page, leaderboards.limit_value, leaderboards.total_count, sort_direction)
      leaderboard
    end
  end

  def calculate_rank(index, page, limit_value, total_count, sort_direction)
    if sort_direction == 'desc'
      ((page - 1) * limit_value) + index + 1
    else
      total_count - ((page - 1) * limit_value) - index
    end
  end
end
