class PopulateInitialGames < ActiveRecord::Migration[7.1]
  def change
    Game.create(name: 'Math Foundation', url: 'https://www.google.com', category: Category.find_by(name: 'Math'))
    Game.create(name: 'Reading Foundation', url: 'https://www.google.com', category: Category.find_by(name: 'Reading'))
    Game.create(name: 'Speaking Foundation', url: 'https://www.google.com', category: Category.find_by(name: 'Speaking'))
    Game.create(name: 'Writing Foundation', url: 'https://www.google.com', category: Category.find_by(name: 'Writing'))
  end
end
