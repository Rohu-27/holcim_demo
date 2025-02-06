class ImageUploader < Shrine
  plugin :validation_helpers
  plugin :determine_mime_type

  Attacher.validate do
    validate_max_size 10*1024*1024    # Max size = 10MB
    validate_mime_type_inclusion %w[image/jpeg image/png image/jpg image]  # Allowed MIME types
    if file.mime_type == 'application/pdf'
      errors << "File Cannot be a PDF"
    end
  end
end