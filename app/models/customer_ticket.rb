class CustomerTicket < ApplicationRecord
  audited
  acts_as_paranoid
  has_one :album, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :album, allow_destroy: true
  validates_associated :album
  validates_presence_of :category
end
