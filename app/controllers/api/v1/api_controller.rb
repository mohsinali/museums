class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  private
    def authenticate_via_token
      ## Check for authorization token in headers. Return if not found.
      if request.headers[:Authorization].blank?
        return render json: { success: false, msg: 'Authentication token not found.' }, status: 401
      end
      
      @token = request.headers[:Authorization]

      begin
        @decoded_token = JWT.decode @token, ENV["HMAC_SECRET"], true, { algorithm: 'HS256' }
        @user = User.find_by(id: @decoded_token.first["data"]["user"]["id"])
        
        ## If token contains invalid user id then return with 401 error
        return render json: {success: false, msg: 'Invalid token.'}, status: 401 if !@user                
      rescue JWT::ExpiredSignature
        return render json: {success: false, msg: 'Token has expired.'}, status: 401
      end
    end
end
