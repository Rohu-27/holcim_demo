class SubCategory < ApplicationRecord
  belongs_to :category
  acts_as_paranoid
end
