# == Schema Information
#
# Table name: hotspots
#
#  id           :bigint           not null, primary key
#  tehsil       :string
#  uc           :string
#  address      :string
#  tag          :string
#  description  :string
#  hotspot_name :string
#  lat          :string
#  long         :string
#  district_id  :integer
#  district     :string
#  is_active    :boolean
#  tehsil_id    :integer
#  uc_id        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tag_id       :integer
#  contact_no   :string
#
class Hotspot < ApplicationRecord
	include HotspotFilterable
	## associations
	has_many :activities, class_name: 'SimpleActivity'
	has_many :archived21_activities, class_name: 'Archived21SimpleActivity'
	has_many :department_tags, :primary_key => 'tag_id', :foreign_key => "tag_id", :class_name => "DepartmentTag"
	belongs_to :updated_by, class_name: 'User', primary_key: "id", foreign_key: 'hotspot_updated_by', optional: true
	## scopes
	scope :active, -> { where("hotspots.is_active is true") }
	scope :get_tehsils, ->(tehsils){where("hotspots.tehsil_id IN(?)", tehsils)}
	scope :get_departments, ->(departments){where("department_tags.department_id =?", departments)}
	scope :filter_by_tehsil_id, ->(data){data.present? ? (where("tehsil_id =?", data) ) : where("true")}
	scope :filter_by_district_id, ->(data){data.present? ? (where("district_id =?", data) ) : where("true")}
	scope :filter_by_uc_id, ->(data){data.present? ? (where("hotspots.uc_id =?", data) ) : where("true")}
	scope :filter_by_uc, ->(data){data.present? ? (where("hotspots.uc_id =?", data) ) : where("true")}
	scope :filter_by_status, ->(data){data.present? ? (where("is_active is #{data}" ) ) : where("true")}
	scope :filter_by_hotspot_status, ->(data){data.present? ? (where("hotspots.is_active is #{data}" ) ) : where("true")}
	scope :filter_by_tag_id, ->(data){data.present? ? (where("tag_id IN (?)", data) ) : where("true")}	
	scope :filter_by_from, ->(data){where("created_at >=?", Time.parse("#{data.to_datetime}").beginning_of_day )}
	scope :filter_by_to, ->(data){where("created_at <=?", Time.parse("#{data.to_datetime}").end_of_day )}
	scope :filter_by_h_name, ->(data){where("lower(hotspot_name) like ?", "%#{data.try(:downcase)}%")}

	## hotspot suummary wise count
	scope :filter_by_hotspot_district_id, ->(data){data.present? ? where("hotspots.district_id =?", data) : where("true")}
	scope :filter_by_hotspot_tehsil_id, ->(data){data.present? ? where("hotspots.tehsil_id =?", data) : where("true")}
	scope :filter_by_hotspot_tag_id, ->(data){data.present? ? (where("hotspots.tag_id IN (?)", data) ) : where("true")}	
	scope :filter_by_hotspot_from, ->(data){where("simple_activities.created_at >= ?", data )}
	scope :filter_by_hotspot_to, ->(data){where("simple_activities.created_at <= ?", data )}

	scope :filter_by_hotspot_from_archive, ->(data){where("archived21_simple_activities.created_at >= ?", data )}
	scope :filter_by_hotspot_to_archive, ->(data){where("archived21_simple_activities.created_at <= ?", data )}


	def self.hotspot_json(hotspot)
		{
			"hotspot_id" => hotspot.id, 
			"town" => hotspot.tehsil, 
			"town_id" => hotspot.tehsil_id, 
			"uc" => hotspot.uc, 
			"uc_id" => hotspot.uc_id, 
			"tag" => hotspot.tag, 
			"tag_id" => hotspot.tag_id, 
			"address" => hotspot.address, 
			"description" => hotspot.description, 
			"hotspot_name" => hotspot.hotspot_name, 
			"contact_no" => hotspot.contact_no,
			"is_tagged"=> hotspot.is_tagged,
		}
	end
end


