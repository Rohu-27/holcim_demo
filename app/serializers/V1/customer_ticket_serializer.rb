class V1::CustomerTicketSerializer < ActiveModel::Serializer
  attributes :id, :category, :sub_category, :description, :status, :user_id, :ticket_number, :comment
  has_one :album, serializer: V1::AlbumSerializer
  attributes :created_at, :updated_at
end