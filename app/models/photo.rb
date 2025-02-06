class Photo < ActiveRecord::Base
  include MyUploader::Attachment(:image)
end