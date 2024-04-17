class Api::UserController < ApplicationController
  def index
    user = UserStatsSerializer.new(current_user)
    render json: {user: user}, status: :ok
  end

  # POST /games
  def game_events
    occurred_at_iso_string = game_event_params[:occurred_at]

    begin
      Time.iso8601(occurred_at_iso_string)
    rescue ArgumentError
      render json: {error: "Invalid datetime format, expecting iso8601"}, status: :unprocessable_entity
      return
    end

    completed_game = Game.find(game_event_params[:game_id])
    offset = parse_offset(occurred_at_iso_string)
    UserGame.create(user: current_user, game: completed_game, occurred_at: occurred_at_iso_string, timezone_offset: offset)

    render json: {status: "Success"}, status: :created
  end

  private
  def game_event_params
    params.require(:game_event).permit(:type, :occurred_at, :game_id)
    # if params[:type] != "COMPLETED"
    #   raise Exception.new("Invalid game event type, expecting COMPLETED")
    #   return
    # end
  end

  def parse_offset(iso_string)
    iso_string[-6...]
  end
end
