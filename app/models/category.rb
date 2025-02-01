class Category < ApplicationRecord
  has_many :sub_categories, dependent: :destroy
  acts_as_paranoid
  accepts_nested_attributes_for :sub_categories, allow_destroy: true
end
