class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: %i[show edit update destroy]

  def index
    @my_games = current_user.games.joinable

    @q = Game.joinable.ransack(params[:q])
    @games = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @game = Game.build
    @path = games_path
    render layout: 'modal'
  end

  def edit
    @path = @game
    render layout: 'modal'
  end

  def create
    @game = Game.build(game_params)

    if @game.save
      @game.users << current_user
      redirect_to games_path, notice: 'Game was successfully created.'
    else
      render :new, status: :unprocessable_entity, layout: 'modal'
    end
  end

  def update
    if @game.update(game_params)
      redirect_to games_path, notice: 'Game was successfully updated.'
    else
      render :edit, status: :unprocessable_entity, layout: 'modal'
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_path, notice: 'Game was successfully destroyed.' }
      format.turbo_stream { flash.now[:notice] = 'Game was successfully destroyed.' }
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name, :required_player_count, :_method, :authenticity_token, :commit)
  end
end
