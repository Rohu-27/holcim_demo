class User < ApplicationRecord
  audited
  acts_as_paranoid
  has_secure_password
  enum role: { user: 0, admin: 1 }
  def admin?
    role=="admin"
  end
  def user?
    role=="user"
  end
end
