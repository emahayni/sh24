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
