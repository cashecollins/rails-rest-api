require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(username: "test", full_name: "Test User")
    @email = "test+1@example.com"
    @password = "Password1!"
  end

  test "should not save user without email" do
    assert_not @user.save
  end

  test "should not save user without password" do
    @user.email = @email
    assert_not @user.save
  end

  test "should save user with email and password" do
    @user.email = @email
    @user.password = @password
    assert @user.save
  end

  test "should not save user with duplicate email" do
    @user.email = users(:one).email
    @user.password = @password
    @user.save
    assert_not @user.save
  end

  test "should calculate streak -> today completed" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (0).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)
    assert_equal 3, user.calculate_streak
  end

  test "should calculate streak -> today not completed" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)
    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> lapsed streak" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (3).day)
    assert_equal 0, user.calculate_streak
  end

  test "should calculate streak -> multiple games on same days" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (0).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:reading_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:speaking_game), occurred_at: Date.current - (1).day)

    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> product test case -> completed today + 2 days" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (0).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)

    assert_equal 3, user.calculate_streak
  end

  test "should calculate streak -> product test case -> completed today + 1 day" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (0).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (1).day)

    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> product test case -> not completed today + 2 days" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)

    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> product test case -> past streak is broken" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (3).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (4).day)


    assert_equal 0, user.calculate_streak
  end

  test "should calculate stats -> full suite" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (0).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)
    UserGame.create(user: user, game: games(:reading_game), occurred_at: Date.current - (0).day)
    UserGame.create(user: user, game: games(:reading_game), occurred_at: Date.current - (1).day)
    UserGame.create(user: user, game: games(:reading_game), occurred_at: Date.current - (2).day)

    stats = user.stats
    assert_equal 6, stats[:total_games_played]
    assert_equal 3, stats[:current_streak_in_days]
    assert_equal 3, stats[:total_math_games_played]
    assert_equal 3, stats[:total_reading_games_played]
    assert_equal 0, stats[:total_speaking_games_played]
    assert_equal 0, stats[:total_writing_games_played]
  end

  test "should calculate stats -> no games played" do
    user = users(:one)
    stats = user.stats
    assert_equal 0, stats[:total_games_played]
    assert_equal 0, stats[:current_streak_in_days]
    assert_equal 0, stats[:total_math_games_played]
    assert_equal 0, stats[:total_reading_games_played]
    assert_equal 0, stats[:total_speaking_games_played]
    assert_equal 0, stats[:total_writing_games_played]
  end

  test "should calculate stats -> missing streak" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (2).day)
    UserGame.create(user: user, game: games(:math_game), occurred_at: Date.current - (3).day)

    stats = user.stats
    assert_equal 2, stats[:total_games_played]
    assert_equal 0, stats[:current_streak_in_days]
    assert_equal 2, stats[:total_math_games_played]
    assert_equal 0, stats[:total_reading_games_played]
    assert_equal 0, stats[:total_speaking_games_played]
    assert_equal 0, stats[:total_writing_games_played]
  end
end
