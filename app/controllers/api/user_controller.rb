class Api::UserController < ApplicationController
  def index
    user = UserStatsSerializer.new(current_user)
    render json: {user: user}, status: :ok
  end

  # POST /games
  def game_events
    completed_game = Game.find(game_event_params[:game_id])
    UserGame.create(user: current_user, game: completed_game, occurred_at: game_event_params[:occurred_at])

    render json: {status: "Success"}, status: :created
  end

  private
  def game_event_params
    params.require(:game_event).permit(:type, :occurred_at, :game_id)
  end
end
