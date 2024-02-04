require 'cloudinary'
require 'cloudinary/uploader'

# ImageUploader -  Module for uploading an image to Cloudinary
class ImageUploader
  attr_accessor :client
  def initialize
    setup_gem
  end

  def upload_image(image_path, name)
    Cloudinary::Uploader.upload(image_path, public_id: name)
  end

  def setup_gem
    return unless Cloudinary.config.api_key.blank?

    require './cloudinary_config'
  end
end
