class User < ApplicationRecord
  has_secure_password
  before_create :set_user_id

  private

  def set_user_id
    last_user=User.last
    next_user_id= last_user.nil? ? 1 : last_user.id.split("-").last.to_i+1
    self.id = "USR-#{next_user_id.to_s.rjust(2, '0')}"
  end

end
