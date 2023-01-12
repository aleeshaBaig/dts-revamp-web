# == Schema Information
#
# Table name: hospitals
#
#  id            :bigint           not null, primary key
#  hospital_name :string
#  district_id   :integer
#  facility_type :string
#  category      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Hospital < ApplicationRecord
	belongs_to :district
	belongs_to :province
	has_many :patients
	has_many :users
	has_one :bed
	has_one :zero_patient	
	has_many :ppe_stocks
	has_many :pcr_machines
	has_many :medicine_stocks

	enum h_type: { "Hospital": 0, "Lab": 1}
	
	## Scopes
	scope :get_labs, ->{where(h_type: "Lab")}
	scope :get_hospitals, ->{where(h_type: "Hospital")}
	# FIlter Scopes
	scope :hospital_name, ->(hospital_name_v) { hospital_name_v.present? ? (where("lower(hospitals.hospital_name) like ?", "#{hospital_name_v.try(:downcase)}%")) : where("true") }
	scope :facility_type, ->(facility_type_v) { facility_type_v.present? ?  all_hospitals(facility_type_v) : where("true") }
	scope :category, ->(category_v) { where("lower(hospitals.category) like ?", "#{category_v.try(:downcase)}%") }
	scope :district_id, ->(district_id_v) { where("hospitals.district_id = ?", "#{district_id_v}") }
	scope :province_id, ->(province_id_v) { where("hospitals.province_id = ?", "#{province_id_v}") }

	scope :filter_by_province_id, ->(data){data.present? ? (where("hospitals.province_id =?", data) ) : where("true")}
	scope :filter_by_district_id, ->(data){data.present? ? (where("hospitals.district_id =?", data) ) : where("true")}
	scope :filter_by_hospital, ->(data){data.present? ? (where("hospitals.id =?", data) ) : where("true")}
	scope :hospital_id, ->(data){data.present? ? (where("hospitals.id =?", data) ) : where("true")}
	
	validates :hospital_name, presence: {message: "Hospital Name can't be blank"}
	# before_save :titleize_name
	# def titleize_name
	# 	self.hospital_name = self.hospital_name.try(:titleize)
	# end	
	before_save :update_h_type

	def update_h_type
		if self.category == 'Lab'
			self.h_type = 'Lab'
		else
			self.h_type = 'Hospital'
		end
	end
	def is_zero_patient_exist(date_from, date_to)
		zero_patient.present? ? "Yes" : "No"
	end

	def self.all_hospitals(facility_type_v)
		if facility_type_v == 'All'
			where("TRUE = FALSE")
			# where("facility_type is not null or facility_type !=?", '')
		else
			where("lower(hospitals.facility_type) like ?", "#{facility_type_v.try(:downcase)}%")
		end
	end
end
