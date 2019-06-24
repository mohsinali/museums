class User < ApplicationRecord
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ##########################################################
  ## Function:      get_jwt_token
  ## Description:   Generates a jwt token using 'HS256' hashing.
  ##                It uses a secret key defined as env variable in application.yml
  ##                and token expiry period(in days) is defined in settings.yml
  ## Params:        NiL
  ## Output:        jwt token
  ##########################################################
  def get_jwt_token
    payload = { data: {user: {id: self.id, email: self.email}} }
    payload[:exp] = (Time.now + Settings.jwt_token_expiry.days).to_i

    JWT.encode payload, ENV["HMAC_SECRET"], 'HS256'
  end
end
