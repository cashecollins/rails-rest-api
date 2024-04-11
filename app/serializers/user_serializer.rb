class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :full_name
end
