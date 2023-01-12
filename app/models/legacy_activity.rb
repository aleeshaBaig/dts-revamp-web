class LegacyActivity < ApplicationRecord
    
    include LegacyActivityFilterable
    ## associations
	
	belongs_to :district, optional: true
    belongs_to :department, optional: true

    ## scopes
    scope :filter_by_district_id, ->(data){data.present? ? (where("legacy_activities.district_id =?", data) ) : where("true")}
    scope :filter_by_department_id, ->(data){data.present? ? (where("legacy_activities.department_id =?", data) ) : where("true")}

	scope :filter_by_from, ->(data){data.present? ? (where("legacy_activities.act_date >=?", Time.parse("#{data}").to_date) ) : where("true")}
	scope :filter_by_to, ->(data){data.present? ? (where("legacy_activities.act_date <=?", Time.parse("#{data}").to_date) ) : where("true")}
end
