class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @games = Game.all
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
      redirect_to @game, notice: 'Game was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    opponent_user_id = params[:opponent_id].to_i
    rank = params[:rank]

    if @game.play_round!(opponent_user_id, rank)
      redirect_to @game, notice: "You asked for a #{rank} from #{User.find(opponent_user_id).name}."
    else
      redirect_to @game, alert: "Turn failed. Please try again."
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

  def turn_params
    params.require(:game).permit(:opponent, :rank)
  end
end
