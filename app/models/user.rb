class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :user_games
  has_many :games, through: :user_games

  def stats
    stats = {
      total_games_played: user_games.count,
      current_streak_in_days: calculate_streak
    }
    category_names = Category.pluck(:name)
    category_names.each do |category_name|
      stats["total_#{category_name.downcase}_games_played".to_sym] = user_games.joins(:game).where(games: { category: Category.find_by(name: category_name) }).count
    end

    stats
  end

  def calculate_streak
    ordered_games = user_games.order(occurred_at: :desc)
    most_recent_game = ordered_games.first
    return 0 unless most_recent_game
    last_played_date = offset_adjusted_date(most_recent_game.occurred_at, most_recent_game.timezone_offset)

    current_local_date = offset_adjusted_date(DateTime.current, most_recent_game.timezone_offset)
    streak = last_played_date == current_local_date ? 1 : 0
    date = current_local_date - 1.day

    ordered_games.each do |user_game|
      game_date = offset_adjusted_date(user_game.occurred_at, user_game.timezone_offset)
      break if game_date < date
      next if game_date > date
      streak += 1
      date -= 1.day
    end

    streak
  end

  private
  def offset_adjusted_date(date, offset)
    (date + offset.to_i.hours).to_date
  end
end
