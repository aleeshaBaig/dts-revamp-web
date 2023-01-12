# == Schema Information
#
# Table name: simple_activities
#
#  id                      :bigint           not null, primary key
#  tag_category_id         :integer
#  tag_category_name       :string
#  larva_found             :boolean
#  larva_type              :integer
#  io_action               :integer
#  removal_water_stagnant  :boolean
#  removal_garbage         :boolean
#  removal_rof_top_cleaned :boolean
#  old_record_sorted       :boolean
#  sops_follow             :boolean
#  comment                 :text
#  tag_name                :string
#  tag_id                  :integer
#  app_version             :integer
#  latitude                :string
#  longitude               :string
#  activity_time           :datetime
#  os_version_number       :integer
#  os_version_name         :string
#  user_id                 :integer
#  hotspot_id              :integer
#  tehsil_id               :integer
#  tehsil_name             :string
#  uc_name                 :string
#  uc_id                   :integer
#  before_picture          :string
#  after_picture           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class Archived21SimpleActivity < ApplicationRecord
	include SimpleActivityFilterable

	## scopes
	scope :ascending, ->{order("archived21_simple_activities.created_at DESC")}
	scope :filter_by_tag, ->(data){where("archived21_simple_activities.tag_id IN(?)", data)}
	scope :filter_by_department, ->(data){data.present? ? where("archived21_simple_activities.department_id =?", data) : where("true")}
	scope :filter_by_multi_department, ->(data){where("archived21_simple_activities.department_id IN(?)", data.split(","))}
	scope :filter_by_io_action, ->(data){where("archived21_simple_activities.io_action =?", data)}
	
	scope :is_larva_found, ->{where("archived21_simple_activities.larva_found is true")}
	scope :is_not_larva_found, ->{where("archived21_simple_activities.larva_found is false")}

	scope :filter_by_uc, ->(data){ data.present? ? where("archived21_simple_activities.uc_id =?", data) : where("true")}
	scope :filter_by_tehsil_id, ->(data){data.present? ? where("archived21_simple_activities.tehsil_id =?", data) : where("true")}
	scope :filter_by_tehsil_ids, ->(data){where("archived21_simple_activities.tehsil_id IN(?)", data)}
	scope :filter_by_district_id, ->(data){data.present? ? where("archived21_simple_activities.district_id =?", data) : where("true")}
	scope :filter_by_tag_id, ->(data){data.present? ? (where("archived21_simple_activities.tag_id IN (?)", data) ) : where("true")}	
	scope :filter_by_act_tag, ->(data){data.present? ? (where("simple_activities.tag_id =?", data) ) : where("true")}
	scope :filter_by_larva_type, ->(data){where("archived21_simple_activities.larva_type = ?", data)}
	scope :filter_by_user_id, ->(data){where("archived21_simple_activities.user_id =?", data)}
	scope :filter_by_status, ->(data){where("mobile_users.status =?", data)}
	scope :filter_by_username, ->(data){where("lower(mobile_users.username) like ?", "%#{data}%".downcase)}
	
	scope :filter_by_mobile_user_ids, ->(data){data.present? ? (where("archived21_simple_activities.user_id IN(?)", data)) : where("true")}
	
	scope :filter_by_from, ->(data){ data.present? ? (where("archived21_simple_activities.created_at::DATE >=?", Time.parse("#{data.to_date}").beginning_of_day ))   : where("true")}
	scope :filter_by_to, ->(data){ data.present? ? (where("archived21_simple_activities.created_at::DATE <=?", Time.parse("#{data.to_date}").end_of_day )) : where("true")}

	scope :filter_by_datefrom, ->(data){data.present? ? (where("archived21_simple_activities.created_at >= ?", data) ) : where("true")}
	scope :filter_by_dateto, ->(data){data.present? ? (where("archived21_simple_activities.created_at <= ?", data) ) : where("true")}

	## hotspots
	scope :filter_by_hotspot_district_id, ->(data){data.present? ? where("archived21_simple_activities.district_id =?", data) : where("true")}
	scope :filter_by_hotspot_tehsil_id, ->(data){data.present? ? where("archived21_simple_activities.tehsil_id =?", data) : where("true")}
	scope :filter_by_hotspot_tag_id, ->(data){data.present? ? (where("archived21_simple_activities.tag_id IN (?)", data) ) : where("true")}	
	scope :filter_by_hotspot_from, ->(data){where("archived21_simple_activities.created_at >= ?", data )}
	scope :filter_by_hotspot_to, ->(data){where("archived21_simple_activities.created_at <= ?", data )}
	scope :filter_by_hotspot_status, ->(data){data.present? ? (where("hotspots.is_active is #{data}" ) ) : where("true")}

	
	scope :positive_and_negative, ->{where(larva_type: [:positive, :negative])}
	scope :all_larvae, ->{where(larva_type: [:positive, :negative, :repeat])}
	
	## enums
	enum larva_type: [:positive, :negative, :repeat]
	enum io_action: [:indoor, :outdoor]
	## associations
	has_one :picture, :as => :pictureable
	
	# belongs_to :user, optional: true
	belongs_to :user, :primary_key => 'id', :foreign_key => "user_id", :class_name => "MobileUser" , optional: true
	belongs_to :tag_category, optional: true
	belongs_to :tag, optional: true
	belongs_to :hotspot, optional: true
	
	belongs_to :district, optional: true
	belongs_to :tehsil, optional: true
	belongs_to :uc, optional: true
	belongs_to :department, optional: true
		
	#validations
	validates :user_id, presence: {message: 'User should be required'}
	validates :tag_category_id, presence: {message: 'Category should be required'}
	validates :tag_id, presence: {message: 'Tag should be required'}	

	#validations
	validates :latitude, presence: {message: 'Latitude should be required'}
	validates :longitude, presence: {message: 'Longitude should be required'}
	validates :activity_time, presence: {message: 'Activity Time should be required'}

	validates :larva_type, inclusion: { in: larva_types.keys, allow_blank: true, message: 'Please select correct Larva Type' }
	validates :io_action, inclusion: { in: io_actions.keys, allow_blank: true, message: 'Please select correct IO Action' }

	## remove extra spaces 
	auto_strip_attributes :uc_name, :tag_name, :tehsil_name, :tag_category_name, :comment, :description, squish: true
	## callbacks
	before_save :missing_data
	def missing_data
		self.district_name = self.district.try(:district_name)
		self.tehsil_name = self.tehsil.try(:tehsil_name)
		self.uc_name = self.uc.try(:uc_name)
		self.department_name = self.department.try(:department_name)
	end
	
	before_save :titleize_data		
	def titleize_data
		self.uc_name = self.uc_name.try(:titleize)
		self.tag_category_name = self.tag_category_name.try(:titleize)
		self.tag_name = self.tag_name.try(:titleize)
		self.tehsil_name = self.tehsil_name.try(:titleize)
		self.comment = self.comment.try(:titleize)
		self.description = self.description.try(:titleize)
	end
	
	before_save :last_visited_date_of_hotspot
	def last_visited_date_of_hotspot
		if hotspot_id.present?
			if hotspot.present?
				hotspot.last_visited = Time.now
				hotspot.save(validate:  false)
			end
		end
	end
	def save_picture(m_before_picture, m_after_picture)
		if create_picture(before_picture: m_before_picture, after_picture: m_after_picture)
			return picture
		end
		nil
	end
	# def before_picture
	# 	picture.present? ? get_realtive_path_image(picture.before_picture.url) : ''
	# end
	# def after_picture
	# 	picture.present? ? get_realtive_path_image(picture.after_picture.url) : ''
	# end

	def get_realtive_path_image(url)
		return url.present? ? "#{url}" : ""
	end
end
