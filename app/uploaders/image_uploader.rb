class ImageUploader < Shrine
  plugin :validation_helpers
  plugin :determine_mime_type

  Attacher.validate do
    validate_max_size 10*1024*1024    # Max size = 10MB
    validate_mime_type %w[image/jpeg image/png image/jpg image]  # Allowed MIME types
  end
end