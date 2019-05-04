class ServiceController < ApplicationController
  include PostcodeUtils

	def index
    @pcode = nil
    @result = nil
    @error = nil
	end

  def check
    @result = false
    @pcode = params[:pcode] || ''
    if !is_valid_postcode?(@pcode )
      @error = 'Please enter a valid UK postcode'
    else
      @result = can_serve_postcode?(@pcode)
    end
    render 'index'
  end

 private

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
        puts "Failed Lookup Postcode (GET) #{e}"
        return ''
    end
  end

  def is_whitelisted_lsoa?(lsoa_value)
    Lsoa.all.each do | lo |
      if lsoa_value.start_with?(lo.value)
        return true
      end
    end
    return false
  end

  def is_whitelisted_postcode?(postcode_value)
    result = Postcode.where(:code => postcode_value)
    return !result.empty?
  end
end
