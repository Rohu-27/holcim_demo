class V1::AlbumSerializer < ActiveModel::Serializer
  attributes :id, :attachments, :images, :created_at, :updated_at
  def attachments
    object.photos.size
  end
  def images
    photos = []
    action = instance_options[:context][:action]
    if action == 'show' || action == 'create'
      object.photos.each do |photo|
        photos.push(V1::PhotoSerializer.new(photo))
      end
    end
    photos
  end
end