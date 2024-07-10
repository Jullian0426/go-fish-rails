class GameUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @game = Game.find(params[:game_id])
    if @game.users.include?(current_user) || @game.enough_players?
      return redirect_to games_path, alert: 'Unable to join game'
    end

    @game_user = @game.game_users.build(user: current_user)

    if @game_user.save
      @game.start!
      redirect_to @game, notice: 'You have joined the game.'
    else
      redirect_to games_path, notice: 'Unable to join game'
    end
  end

  def destroy
    @game_user = GameUser.find_by(game_id: params[:game_id], user_id: current_user.id)

    if @game_user
      @game_user.destroy
      redirect_to games_path, notice: 'You have left the game.'
    else
      redirect_to games_path, alert: 'Unable to leave game.'
    end
  end
end
