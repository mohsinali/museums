class Api::V1::MuseumsController <  Api::V1::ApiController
  before_action :authenticate_via_token
  
  def index
  end
end
