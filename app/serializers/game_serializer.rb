class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :category

  def category
    object.category.name
  end
end
