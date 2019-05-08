class Lsoa < ApplicationRecord
	validates :value, presence: true, uniqueness: true,
                   length: { minimum: 5, maximum: 25 }

  validates :description, presence: true,
                   length: { maximum: 50 }

	before_save :modify_string_case

	def modify_string_case
		self.value.downcase!
	end      
end
