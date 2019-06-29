module Api::V1::MuseumsHelper
  
  ## ###########################
  ## Function:      extract_data
  ## @param         places  [A hash of Mapbox Api response]
  ## Description:   It traverse the places hash to get the data.
  ## Output:        Returns a hash of places grouped by postcodes.
  def extract_data places
    postcodes = {}
    places.first['features'].each do |feature|      
      ## extract postcode from feature
      p_code = get_postcode(feature)
            
      if postcodes.has_key?(p_code)
        postcodes[p_code].push(feature['place_name'])
      else
        postcodes[p_code] = [feature['place_name']]
      end
    end

    return postcodes
  end

  ## ###########################
  ## Function:      get_postcode
  ## @param         feature
  ## Description:   It takes a hash with key 'feature' from MapboxApi response.
  ##                Finds a postcode from a nested hash with key 'context'
  ## Output:        A string of postcode or wikidata.
  def get_postcode feature
    p_code = ""
    
    ## First try to find postcode. If found, return postcode.
    p_code = feature['context'].find{|cxt| cxt['id'].include?('postcode')}
    return p_code['text'] unless p_code.nil?

    ## If postcode is not found, then try to find wikidata
    p_code = feature['context'].find{|cxt| cxt['id'].include?('locality')}
    return p_code['wikidata'] unless p_code.nil?
  end

  
end
