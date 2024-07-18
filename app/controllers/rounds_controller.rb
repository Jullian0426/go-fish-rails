class RoundsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game

  def create
    opponent_user_id = round_params[:opponent_id].to_i
    rank = round_params[:rank]

    @game.play_round!(opponent_user_id, rank)
    redirect_to @game
  rescue GoFish::InvalidRank
    flash[:alert] = 'You must select a rank.'
    redirect_to @game
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def round_params
    params.permit(:opponent_id, :rank, :game_id, :_method, :authenticity_token, :commit)
  end
end
