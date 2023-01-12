# == Schema Information
#
# Table name: tehsils
#
#  id          :bigint           not null, primary key
#  tehsil_name :string
#  district_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Tehsil < ApplicationRecord
	## associations
	belongs_to :district, optional: true
	has_many :ucs	
	has_and_belongs_to_many :mobile_users, join_table: "mobile_user_tehsils"
	## remove extra spaces 
	auto_strip_attributes :tehsil_name, squish: true
	validates :tehsil_name, presence: {message: "Tehsil Name can't be blank"}, uniqueness: {message: "Tehsil Name should be unique", scope: :district_id}
	## callbacks

	# before_save :titleize_data

	# def titleize_data
	# 	self.tehsil_name = self.tehsil_name.try(:titleize)
	# end
end
