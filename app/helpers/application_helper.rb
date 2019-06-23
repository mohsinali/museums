module ApplicationHelper
  def generate_token user
    payload = { data: {user: {id: user.id, email: user.email}} }
    payload[:exp] = (Time.now + 10.days).to_i
    
    JWT.encode payload, ENV["HMAC_SECRET"], 'HS256'
  end
end
