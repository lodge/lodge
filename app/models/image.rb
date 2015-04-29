class Image < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  mount_uploader :image, ImageUploader
end
