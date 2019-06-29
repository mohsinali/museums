module MapboxApi
  extend ActiveSupport::Concern

  class Places
    def initialize lat, lng, search_text
      @lat         = lat
      @lng         = lng
      @search_text = search_text
      Mapbox.access_token = ENV["MAPBOX_API_KEY"]
    end

    ## ###########################
    ## Function:      find    
    ## Description:   It uses Mapbox forward geocoding function to get places around the given proximity.
    ## Output:        Returns the Mapbox Api response.
    def find
      placenames = []
      begin
        placenames = Mapbox::Geocoder.geocode_forward(
          @search_text, 
          {:proximity => {:longitude => @lng, :latitude => @lat}}
          )
      rescue Exception => e
        puts "====================== Exception - MapboxApi - Places - find ======================"
        puts e.message
      end

      return placenames
    end
  end
    
end