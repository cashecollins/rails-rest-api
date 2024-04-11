require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @math_game = games(:math_game)
    jwt = jwt()
    @headers = { "Authorization" => "Bearer #{jwt}" }
  end

  test "should get index" do
    get '/api/games', as: :json, headers: @headers
    assert_response :success
  end
end
