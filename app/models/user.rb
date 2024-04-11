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
      stats["total_#{category_name.downcase}_games_played"] = user_games.joins(:game).where(games: { category: Category.find_by(name: category_name) }).count
    end

    stats
  end

  private
  def calculate_streak
    last_played_date = user_games.order(occurred_at: :desc).pluck(:occurred_at).first
    return 0 unless last_played_date

    streak = last_played_date == Date.current ? 1 : 0
    date = Date.current - 1.day

    while user_games.where(occurred_at: date).exists?
      streak += 1
      date -= 1.day
    end

    streak
  end
end
