module PostcodeUtils

	# From GitHub: https://gist.github.com/mudge/163332
  def is_valid_postcode?(postcode)
     # We use !! to convert the return value to a boolean:
    !!(postcode =~ /^\s*((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))\s*$/i)
  end

  def check_postcode_format(postcode)
    if postcode.blank?
      return false
    end

    # Postcode Allowed Formats: (A: Letter, N: Number)
    # AN   NAA
    # ANN  NAA
    # AAN  NAA
    # ANA  NAA
    # AANN NNA
    # AANA NAA

    case postcode.length
      when 6
        return postcode.match(/[a-z]\d\s\d[a-z]{2}/)
      when 7
        return postcode.match(/[a-z]\d{2}\s\d[a-z]{2}/) || postcode.match(/[a-z]\d[a-z]\s\d[a-z]{2}/) || postcode.match(/[a-z]{2}\d\s\d[a-z]{2}/)
      when 8
        return postcode.match(/[a-z]{2}\d{2}\s\d[a-z]{2}/) || postcode.match(/[a-z]{2}\d[a-z]\s\d[a-z]{2}/)
      else
        return false
    end
  end

  def is_valid_postcode_2(pcode)
    cleaned_pcode = pcode.gsub('/\s+/','')
    require 'net/http'
    require 'json'
    begin
      uri = URI('http://api.postcodes.io/postcodes/' + cleaned_pcode)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.path)
      resp = http.request(req)
      json = JSON.parse(res.body)
      return json["status"] == 200
    rescue => e
      puts "Failed Lookup Postcode (POST) #{e}"
      return false
    end
  end

end