class ZeroPatient < ApplicationRecord
	## enums
	enum t_type: %w(patient lab_patient)

	scope :filter_by_province_id, ->(data){data.present? ? (where("zero_patients.province_id =?", data) ) : where("true")}
	scope :filter_by_district_id, ->(data){data.present? ? (where("zero_patients.district_id =?", data) ) : where("true")}
	scope :filter_by_hospital_id, ->(data){data.present? ? (where("zero_patients.hospital_id =?", data) ) : where("true")}
	scope :filter_by_from, ->(data){data.present? ? (where("zero_patients.created_at::DATE >=?", Time.parse("#{data}").to_date)) : where("true")}
	scope :filter_by_to, ->(data){data.present? ? (where("zero_patients.created_at::DATE <=?", Time.parse("#{data}").to_date)) : where("true")}
	scope :filter_by_lab_id, ->(data){data.present? ? (where("zero_patients.lab_id =?", data) ) : where("true")}

	## relationshipts
	belongs_to :g_district, class_name: "District", primary_key: "id", foreign_key: 'district_id'
	belongs_to :g_hospital, class_name: "Hospital", primary_key: "id", foreign_key: 'hospital_id', optional: true
	belongs_to :g_lab, class_name: "Lab", primary_key: "id", foreign_key: 'lab_id', optional: true
	belongs_to :province, optional: true

	before_save :titleize_name
	def titleize_name
		self.hospital = self.g_hospital.hospital_name if self.g_hospital.present?
		self.district = self.g_district.district_name if self.g_district.present?
		self.province_id = (self.g_district.present? ?  self.g_district.province.id : nil)
		self.lab = self.g_lab.lab_name if self.g_lab.present?
	end		
end
