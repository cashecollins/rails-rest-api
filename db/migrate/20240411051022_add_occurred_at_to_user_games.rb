class AddOccurredAtToUserGames < ActiveRecord::Migration[7.1]
  def change
    add_column :user_games, :occurred_at, :date
  end
end
