RSpec.describe Api::V1::MuseumsController do
  describe "GET #index" do
    before do
      @user = create(:user)
      request.headers["Authorization"] = @user.get_jwt_token
      get :index, format: :json
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end