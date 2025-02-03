class Album < ActiveRecord::Base
  belongs_to :complaint
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates_associated :photos
end