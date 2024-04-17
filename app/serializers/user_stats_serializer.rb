class UserStatsSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :full_name, :stats

  def id
    object.id.to_s
  end
end