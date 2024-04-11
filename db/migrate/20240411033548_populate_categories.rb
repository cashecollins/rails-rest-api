class PopulateCategories < ActiveRecord::Migration[7.1]
  def change
    categories = [
      'Math',
      'Reading',
      'Speaking',
      'Writing',
    ]

    categories.map do |category|
      Category.create(name: category)
    end
  end
end
