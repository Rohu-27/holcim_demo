class V1::ComplaintSerializer < ActiveModel::Serializer
  attributes :id, :category, :sub_category, :description, :status, :user_id
  has_one :album, serializer: V1::AlbumSerializer
  attributes :created_at, :updated_at
end