class V1::UserSerializer < ActiveModel::Serializer
  attributes :user_id, :email, :created_at, :updated_at, :role
  def user_id
    "USR-#{object.id.to_s.rjust(3,'0')}"
  end
end
