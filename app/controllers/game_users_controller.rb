class GameUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @game = Game.find(params[:game_id])
    @game_user = @game.game_users.build(user: current_user)

    if @game.users.include?(current_user)
      redirect_to games_path, alert: 'You have already joined this game.'
    elsif @game_user.save
      redirect_to @game, notice: 'You have joined the game.'
    else
      redirect_to games_path, notice: 'Unable to join game'
    end
  end
end