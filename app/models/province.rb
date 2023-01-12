# == Schema Information
#
# Table name: provinces
#
#  id            :bigint           not null, primary key
#  province_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Province < ApplicationRecord
	has_many :districts
	has_many :divisions
	
	validates :province_name, presence: {message: "Province Name can't be blank"}, uniqueness: {message: "Province Name already taken", :case_sensitive => false}
	
	# before_save :titleize_name
	# def titleize_name
	# 	self.province_name = self.province_name.try(:titleize)
	# end

end
