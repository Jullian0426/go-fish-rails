class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def new
    @game = Game.build
    @path = games_path
  end

  def edit
    @game = Game.find(params[:id])
    @path = @game
  end

  def create
    @game = Game.build(game_params)

    if @game.save
      redirect_to games_path, notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      redirect_to @game, notice: 'Game was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path, notice: 'Game was successfully deleted.'
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
