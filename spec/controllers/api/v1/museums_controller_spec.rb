RSpec.describe Api::V1::MuseumsController do
  describe "GET #index" do
    before do
      get :index, format: :json
    end

    it "returns http success" do      
      expect(response).to have_http_status(:success)
    end
  end
end