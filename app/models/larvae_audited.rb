class LarvaeAudited < ApplicationRecord
	include LarvaeAuditedFilterable

	scope :filter_by_district_id, ->(data){where("simple_activities.district_id =?", data)}
	scope :filter_by_tehsil_id, ->(data){where("simple_activities.tehsil_id =?", data)}
	scope :filter_by_department, ->(data){where("simple_activities.department_id =?", data)}
	scope :filter_by_from, ->(data){where("larvae_auditeds.created_at::DATE >=?", Time.parse("#{data.to_date}") )}
	scope :filter_by_to, ->(data){where("larvae_auditeds.created_at::DATE <=?", Time.parse("#{data.to_date}") )}

	
	has_one :picture, :as => :pictureable
	belongs_to :simple_activity

	def is_satisfactory?
		larviciding == true
	end
end
