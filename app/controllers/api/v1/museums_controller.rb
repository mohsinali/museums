class Api::V1::MuseumsController <  Api::V1::ApiController
  before_action :authenticate_via_token
  include MapboxApi
  include Api::V1::MuseumsHelper
  
  ## ##########################################
  ## GET/museums
  ## @params
  ##      @lat
  ##      @lng
  def index    
    ## Check required parameters
    if params[:lat].blank? || params[:lng].blank?
      return render json: { success: false, msg: 'Latitude and longitude is required.' }, status: 422
    end

    ## Call Mapbox Api to get places data
    @places = Places.new(params[:lat].to_f, params[:lng].to_f, 'museums').find()
    
    ## Extract and format data from api response
    data = extract_data(@places)

    respond_to do |format|
      format.json {render json: data}
    end
  end
end