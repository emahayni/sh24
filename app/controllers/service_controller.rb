class ServiceController < ApplicationController
  include PostcodeUtils

  @@Postcode_URL = 'http://api.postcodes.io/postcodes'

	def index
    @result = nil
    @pcode = nil
	end

  def check
    puts 'Method: Check'
    puts params.inspect

    @pcode = params[:pcode] || ''
    @result = can_serve_postcode(@pcode)
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
      uri = URI(@@Postcode_URL)
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
        return false
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


  def look_postcode(pcode)
    cleaned_pcode = pcode.gsub('/\s+/','')
    require 'net/http'
    require 'json'
    begin
      uri = URI(@@Postcode_URL + '/' + cleaned_pcode)
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
