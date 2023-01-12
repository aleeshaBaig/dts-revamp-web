class TpvAudit < ApplicationRecord
	enum activity_type: [:simple_activity, :patient_activity]
	belongs_to :district, optional: true
	belongs_to :tehsil, optional: true
	belongs_to :department, optional: true
	before_save :table_names


	def table_names
		self.district_name = self.district.try(:district_name)
		self.tehsil_name = self.tehsil.try(:tehsil_name)
		self.department_name = self.district.try(:district_name)
	end
end
