# == Schema Information
#
# Table name: divisions
#
#  id            :bigint           not null, primary key
#  division_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  province_id   :integer
#
class Division < ApplicationRecord
	belongs_to :province
	has_many :districts

	# before_save :titleize_name
	# def titleize_name
	# 	self.division_name = self.division_name.try(:titleize)
	# end
end
