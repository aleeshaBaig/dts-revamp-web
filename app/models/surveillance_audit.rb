class SurveillanceAudit < ApplicationRecord
	include SurveillanceAuditFilterable

	scope :filter_by_district_id, ->(data){where("simple_activities.district_id =?", data)}
	scope :filter_by_tehsil_id, ->(data){where("simple_activities.tehsil_id =?", data)}
	scope :filter_by_department, ->(data){where("simple_activities.department_id =?", data)}
	scope :filter_by_from, ->(data){where("surveillance_audits.created_at::DATE >=?", Time.parse("#{data.to_date}") )}
	scope :filter_by_to, ->(data){where("surveillance_audits.created_at::DATE <=?", Time.parse("#{data.to_date}") )}
	scope :filter_by_indoor_outdoor, ->(data){where("surveillance_audits.is_indoor =?", data)}

	has_one :picture, :as => :pictureable
	belongs_to :simple_activity

	NO_OF_CONTAINERS = {0 => "Less than 2", 1 => "Between 7 and 12", 2 => "More than 13", 3=>"Between 3 and 6"}
	TIME_TAKEN = {0 => "Less than 5 mins", 1 => "5 to 15 mins", 2 => "More than 15 mins"}


	def rooftop_checked_values
		(rooftop_checked == true or rooftop_checked == '' or rooftop_checked == nil)
	end

	def is_satisfactory_indoor?
		(material_provided == true and
		(no_of_containers_checked == 1 or no_of_containers_checked == 2) and
		rooftop_checked != false and
		time_taken == 2 and
		larvae_found == false)
	end
end
