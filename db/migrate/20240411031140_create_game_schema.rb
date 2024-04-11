class CreateGameSchema < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    create_table :games do |t|
      t.string :name
      t.string :url
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    create_table :user_games do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
