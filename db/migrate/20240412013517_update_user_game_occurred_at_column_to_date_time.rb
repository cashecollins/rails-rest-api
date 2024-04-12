class UpdateUserGameOccurredAtColumnToDateTime < ActiveRecord::Migration[7.1]
  def change
    change_column :user_games, :occurred_at, :datetime
    add_column :user_games, :timezone_offset, :string
  end
end
