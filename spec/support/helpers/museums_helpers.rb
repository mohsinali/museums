module MuseumsHelpers
  def invalid_token
    payload = { data: {user: {id: 0, email: 'user@example.com'}} }
    payload[:exp] = (Time.now + Settings.jwt_token_expiry.days).to_i

    JWT.encode payload, ENV["HMAC_SECRET"], 'HS256'
  end

  def expired_token
    payload = {}
    payload[:exp] = (Time.now - 1.day).to_i

    JWT.encode payload, ENV["HMAC_SECRET"], 'HS256'
  end
end