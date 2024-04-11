require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    jwt = jwt()
    @headers = { "Authorization" => "Bearer #{jwt}" }
  end

  test "should get index" do
    get '/api/user', as: :json, headers: @headers
    assert_response :success
  end

  test "should create game event" do
    assert_difference("UserGame.count") do
      post '/api/user/game_events', params: { game_event: { type: "COMPLETE", occurred_at: Date.current, game_id: 1 } }, as: :json, headers: @headers
    end

    assert_response :created
  end
end
