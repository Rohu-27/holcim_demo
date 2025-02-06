class User < ApplicationRecord

  audited
  acts_as_paranoid
  has_secure_password
  has_many :customer_tickets, dependent: :destroy

  validates :email, presence: true

  validates :password, length: { minimum: 6, maximum: 20 }

  enum role: { user: 0, admin: 1 }
  def admin?
    role=="admin"
  end
  def user?
    role=="user"
  end
end
