class Photo < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
end