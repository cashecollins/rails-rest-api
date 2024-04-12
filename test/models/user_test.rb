require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    freeze_time
    travel_to DateTime.parse('2024-04-12 12:00:00')
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
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (0).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')
    assert_equal 3, user.calculate_streak
  end

  test "should calculate streak -> today not completed" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')
    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> lapsed streak" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (3).day, timezone_offset: '+00:00')
    assert_equal 0, user.calculate_streak
  end

  test "should calculate streak -> multiple games on same days" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (0).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:reading_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:speaking_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')

    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> product test case -> completed today + 2 days" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (0).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')

    assert_equal 3, user.calculate_streak
  end

  test "should calculate streak -> product test case -> completed today + 1 day" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (0).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')

    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> product test case -> not completed today + 2 days" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')

    assert_equal 2, user.calculate_streak
  end

  test "should calculate streak -> product test case -> past streak is broken" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (3).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (4).day, timezone_offset: '+00:00')


    assert_equal 0, user.calculate_streak
  end

  test "should calculate stats -> full suite" do
    user = users(:one)
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (0).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:reading_game), occurred_at: DateTime.current - (0).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:reading_game), occurred_at: DateTime.current - (1).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:reading_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')

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
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (2).day, timezone_offset: '+00:00')
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.current - (3).day, timezone_offset: '+00:00')

    stats = user.stats
    assert_equal 2, stats[:total_games_played]
    assert_equal 0, stats[:current_streak_in_days]
    assert_equal 2, stats[:total_math_games_played]
    assert_equal 0, stats[:total_reading_games_played]
    assert_equal 0, stats[:total_speaking_games_played]
    assert_equal 0, stats[:total_writing_games_played]
  end

  test "should calculate streak -> timezone -> local rollover a day -> not completed today + 3 days" do
    user = users(:one)
    travel_to DateTime.parse('2024-04-12 20:00:00') # current_local_date: 2024-04-13 01:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-12 06:00:00'), timezone_offset: '+05:00') # yesterday at 1:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-10 20:00:00'), timezone_offset: '+05:00') # yesterday at 15:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-09 20:00:00'), timezone_offset: '+05:00') # day before yesterday at 15:00:00
    assert_equal 3, user.calculate_streak
  end

  test "should calculate streak -> timezone -> local rollback a day -> not completed today + 3 days" do
    user = users(:one)
    travel_to DateTime.parse('2024-04-13 04:00:00') # current_local_date: 2024-04-12 23:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-11 06:00:00'), timezone_offset: '-05:00') # yesterday at 1:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-10 20:00:00'), timezone_offset: '-05:00') # yesterday at 15:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-09 20:00:00'), timezone_offset: '-05:00') # day before yesterday at 15:00:00
    assert_equal 3, user.calculate_streak
  end

  test "should calculate streak -> timezone -> local start rollover a day -> completed today + 3 days" do
    user = users(:one)
    travel_to DateTime.parse('2024-04-11 20:00:00') # current_local_date: 2024-04-12 01:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-11 20:00:00'), timezone_offset: '+05:00') # today at 01:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-11 06:00:00'), timezone_offset: '+05:00') # 1 day ago at 11:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-10 07:00:00'), timezone_offset: '+05:00') # 2 day ago at 12:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-09 07:00:00'), timezone_offset: '+05:00') # 3 day ago at 12:00:00   
     assert_equal 4, user.calculate_streak
  end

  test "should calculate streak -> timezone -> local start rollback a day -> completed today + 3 days" do
    user = users(:one)
    travel_to DateTime.parse('2024-04-13 04:00:00') # current_local_date: 2024-04-12 23:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-13 04:00:00'), timezone_offset: '-05:00') # today at 23:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-11 06:00:00'), timezone_offset: '-05:00') # 1 day ago at 1:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-10 20:00:00'), timezone_offset: '-05:00') # 2 day ago at 15:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-09 20:00:00'), timezone_offset: '-05:00') # 3 day ago at 15:00:00
    assert_equal 4, user.calculate_streak
  end

  test "should calculate streak -> timezone -> local rollback day mid streak -> completed today + 3 days" do
    user = users(:one)
    travel_to DateTime.parse('2024-04-13 04:00:00') # current_local_date: 2024-04-12 23:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-12 20:00:00'), timezone_offset: '-05:00') # today at 15:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-12 01:00:00'), timezone_offset: '-05:00') # 1 day ago at 1:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-10 20:00:00'), timezone_offset: '-05:00') # 2 day ago at 15:00:00
    UserGame.create(user: user, game: games(:math_game), occurred_at: DateTime.parse('2024-04-09 20:00:00'), timezone_offset: '-05:00') # 3 day ago at 15:00:00
    assert_equal 4, user.calculate_streak
  end
end
