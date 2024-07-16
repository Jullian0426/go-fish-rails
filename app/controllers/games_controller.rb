class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @games = Game.order(created_at: :desc)
  end

  def show
  end

  def new
    @game = Game.build
    @path = games_path
  end

  def edit
    @path = @game
  end

  def create
    @game = Game.build(game_params)

    if @game.save
      @game.users << current_user
      respond_to do |format|
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.turbo_stream { flash.now[:notice] = 'Game was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      redirect_to @game, notice: 'Game was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy
    redirect_to games_path, notice: 'Game was successfully deleted.'
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name, :required_player_count)
  end
end
