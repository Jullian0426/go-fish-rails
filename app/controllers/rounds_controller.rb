class RoundsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game

  def create
    opponent_user_id = round_params[:opponent_id].to_i
    rank = round_params[:rank]

    if @game.play_round!(opponent_user_id, rank)
      redirect_to @game, notice: "You asked for a #{rank} from #{User.find(opponent_user_id).name}."
    else
      redirect_to @game, alert: "Turn failed. Please try again."
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def round_params
    params.permit(:opponent_id, :rank)
  end
end