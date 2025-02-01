class JwtToken
  # SECRET_KEY = Rails.application.secrets.secret_key_base
  SECRET_KEY="415cd440e9272ccd76ac374e2b102f8cae5fafdaf1599f49207668aac05478e331a45e1cc80acc789e675aa50257f96344c05dde0d6031083b755fcbfdabeeaf"

  def self.encode(payload,exp=2.hours.from_now)
    payload[:exp]=exp.to_i
    JWT.encode(payload,SECRET_KEY,'HS256')
  end

  def self.decode(token)
    begin
      JWT.decode(token,SECRET_KEY, true, algorithm: 'HS256')[0]
    rescue => e
      Rails.logger.error "Jwt decoded error #{e.message}"
      nil
    end
  end

end