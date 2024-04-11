class Api::GamesController < ApplicationController
  # GET /games
  def index
    # TODO: fix this cuz it sucks
    games = Game.all.map do |game|
      GameSerializer.new(game)
    end

    render json: {"games": games}, status: :ok
  end
end
