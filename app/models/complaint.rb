class Complaint < ApplicationRecord
  audited
  acts_as_paranoid
  has_one :album, dependent: :destroy
  belongs_to :user
  validates_associated :album
  validates_presence_of :category
end
