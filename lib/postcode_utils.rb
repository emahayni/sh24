module PostcodeUtils

	# From GitHub: https://gist.github.com/mudge/163332
  def is_valid_postcode?(postcode)
     # We use !! to convert the return value to a boolean:
    !!(postcode =~ /^\s*((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))\s*$/i)
  end

  def can_serve_postcode?(pcode)
    if is_whitelisted_postcode?(pcode)
      return true
    end

    lsoa_value = get_Lsoa_from_Postcode(pcode)
    if lsoa_value.nil? || lsoa_value.empty?
      return false
    end 

    if is_whitelisted_lsoa?(lsoa_value)
      return true
    end

    return false
  end

  def get_Lsoa_from_Postcode(postcode_value)
    require 'net/http'
    require 'json'
    begin
      uri = URI('http://api.postcodes.io/postcodes')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
      req.body = {"postcodes" => [postcode_value] }.to_json
      res = http.request(req)
      json = JSON.parse(res.body)
      if json["status"] == 200
        json["result"].each do |entry|
          return entry["result"]["lsoa"].downcase
        end
      end
      rescue => e
        puts "Failed Lookup Postcode (POST) #{e}"
        return ''
    end
  end
end