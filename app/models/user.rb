class User < ApplicationRecord
  audited
  acts_as_paranoid
  has_secure_password
  has_many :complaint, dependent: :destroy
  enum role: { user: 0, admin: 1 }
  def admin?
    role=="admin"
  end
  def user?
    role=="user"
  end
end
