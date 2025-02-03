class V1::PhotoSerializer < ActiveModel::Serializer
  attributes :id, :album_id, :image_url, :created_at, :updated_at

  def image_url
    "#{Rails.application.config.x.base_url}#{object.image_url}"
  end
end
