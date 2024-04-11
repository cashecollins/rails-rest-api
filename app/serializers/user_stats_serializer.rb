class UserStatsSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :full_name, :stats
end