class Api::GamesController < ApplicationController
  # GET /games
  def index
    games = Game.all.map do |game|
      GameSerializer.new(game)
    end

    render json: {games: games}, status: :ok
  end
end
