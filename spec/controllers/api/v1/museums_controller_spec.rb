require './spec/support/helpers/museums_helpers'

RSpec.configure do |c|
  c.include MuseumsHelpers
end

RSpec.describe Api::V1::MuseumsController do
  describe "GET #index" do
    before do
      @user = create(:user)
      @coordinates_germany = {:lat => 52.494857, :lng => 13.437641}  ## Results in a data having postcodes
      @coordinates_japan = {:lat => 35.652832, :lng => 139.839478}   ## Results in a data without postcodes
    end

    it "returns 401 if authentication token is not provided." do
      get :index, as: :json
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(401)
      expect(json_response["msg"]).to match('Authentication token not found.')
    end

    it "returns 401 if token is invalid." do
      request.headers["Authorization"] = invalid_token()
      get :index, as: :json            
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(401)
      expect(json_response["msg"]).to match('Invalid token.')
    end

    it "returns 401 if token is expired." do
      request.headers["Authorization"] = expired_token()
      get :index, as: :json            
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(401)
      expect(json_response["msg"]).to match('Token has expired.')
    end
    
    it "returns http success and groups data with postcodes" do
      request.headers["Authorization"] = @user.get_jwt_token
      
      params = @coordinates_germany
      get :index, params: params, as: :json

      expect(response).to have_http_status(:success)
    end

    it "should not have any empty key if postcodes are not present" do
      params = @coordinates_japan
      request.headers["Authorization"] = @user.get_jwt_token
      
      get :index, params: params, as: :json
      json_response = JSON.parse(response.body)
      key = json_response.keys.find{|k| k.blank? }

      expect(key).to match(nil)
    end

  end
end