class V1::ComplaintSerializer < ActiveModel::Serializer
  attributes :id, :complaint_number, :category, :sub_category, :description, :status, :user_id
  has_one :album, serializer: V1::AlbumSerializer
  attributes :created_at, :updated_at
  def complaint_number
    "CM-#{object.id.to_s.rjust(3,'0')}"
  end
end