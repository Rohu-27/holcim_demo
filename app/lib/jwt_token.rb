class JwtToken
  SECRET_KEY=Rails.application.secret_key_base

  def self.encode(payload,exp=2.hours.from_now)
    payload[:exp]=exp.to_i
    JWT.encode(payload,SECRET_KEY,'HS256')
  end

  def self.decode(token)
    begin
      token = token.split.last
      JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')[0]
    rescue => e
      Rails.logger.error "Jwt decoded error #{e.message}"
      nil
    end
  end

end