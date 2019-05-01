class Postcode < ApplicationRecord
	validates :code, presence: true,
                   length: { minimum: 6, maximum: 8 }

  validates :description, presence: true,
                   length: { maximum: 50 }

  validate :validate_postcode

  before_save :modify_string_case

  def modify_string_case
    self.code.upcase!
  end  

	def validate_postcode
		if !is_valid_postcode?(self.code)
			errors.add(:code, ': Invalid UK postcode')
		end
	end
  
  # From GitHub: https://gist.github.com/mudge/163332
  def is_valid_postcode?(postcode)
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
end
