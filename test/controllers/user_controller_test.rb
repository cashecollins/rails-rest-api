require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  setup do
    freeze_time
    travel_to DateTime.parse('2024-04-12T12:00:00+00:00')
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
      post '/api/user/game_events', params: { game_event: { type: "COMPLETE", occurred_at: Time.now, game_id: 1 } }, as: :json, headers: @headers
    end

    puts UserGame.last.occurred_at
    assert_response :created
  end
end
