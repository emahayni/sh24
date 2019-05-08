class Postcode < ApplicationRecord
  include PostcodeUtils

	validates :code, presence: true, uniqueness: true,
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
end
