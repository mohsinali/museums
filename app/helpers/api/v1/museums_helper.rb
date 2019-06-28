module Api::V1::MuseumsHelper
  
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
  def get_postcode feature
    p_code = ""
    feature['context'].each do |cxt|
      if cxt['id'].include?('postcode')
        p_code = cxt['text']
      end
    end

    return p_code
  end

  
end
