# == Schema Information
#
# Table name: districts
#
#  id            :bigint           not null, primary key
#  district_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  province_id   :integer
#  division_id   :integer
#
class District < ApplicationRecord
	belongs_to :province #, optional: true
	belongs_to :division, optional: true
	has_many :hospitals
	has_many :tehsils
	has_many :ucs
	has_many :mobile_users
	has_many :labs
	has_many :insecticides
	
	validates :district_name, presence: {message: "District Name can't be blank"}, uniqueness: {message: "District Name should be unique", scope: :province_id}
	validates :province_id, presence: {message: "Province Name can't be blank"}

	# before_save :titleize_name
	# def titleize_name
	# 	self.district_name = self.district_name.try(:titleize)
	# end

	before_save :get_division_name
	def get_division_name
		self.division_name = division.try(:division_name)
	end
end
