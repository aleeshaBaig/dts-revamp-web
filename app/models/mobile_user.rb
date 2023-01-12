# == Schema Information
#
# Table name: mobile_users
#
#  id              :bigint           not null, primary key
#  username        :string
#  password_digest :string
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_logged_in    :boolean
#  district        :string
#  district_id     :integer
#  uc              :string
#  uc_id           :integer
#  department_id   :integer
#
class MobileUser < ApplicationRecord
	include MobileUserFilterable
	#serialize :tehsil_ids, Array
	has_secure_password 

	## tag categories ["General","Hotspots", "Larvae", "Patient"]
	## many to many relationsship
	# has_many :user_categories
	# has_many :tag_categories, through: :user_categories

	has_and_belongs_to_many :tag_categories, join_table: "user_categories"
	has_and_belongs_to_many :tehsils, join_table: "mobile_user_tehsils"
	
	belongs_to :get_district, class_name: "District", primary_key: "id", foreign_key: 'district_id', optional: true
	belongs_to :department, optional: true
	belongs_to :division, optional: true

	has_many :simple_activities, :primary_key => 'id', :foreign_key => "user_id"
	
	validates :username, presence: {message: "User Name can't be blank"}, uniqueness: {message: "User Name should be unique"}
	validates :role, presence:{message: "Please Select Role"}
	validates :department_id, presence:{message: "Please Select Department"}, unless: Proc.new{|user| user.is_dengue_situation_app_user?}
	validates :district_id, presence:{message: "Please Select District"}, unless: Proc.new{|user| user.is_divisional_user?}
	validates :tehsils, presence:{message: "Please Select any Tehsil"}, unless: Proc.new{|user| user.is_dengue_situation_app_user?}
	validates :tag_categories, presence:{message: "Please Select any Tag Category"}, if: Proc.new{|user| user.is_anti_dengue_user?}
	
	validates :division_id, presence:{message: "Please Select Division"}, if: Proc.new{|user| user.is_divisional_user?}

	validates :password, presence: true, length: { minimum: 6 }, on: :create
	validates :password, presence: true, length: { minimum: 6 }, if: Proc.new{|user| user.password.present?}
	# FIlter Scopes

	## default
	scope :district_id, ->(data) { where("mobile_users.district_id = ?", data) }
	scope :username, ->(username_v) { where("lower(mobile_users.username) like ?", "%#{username_v.try(:downcase)}%") }
	scope :role, ->(role_v) { where("mobile_users.role = ?", "#{role_v}") }
	scope :status, ->(data) { where("mobile_users.status is #{data}") }

	## summary of activities user wise report
	scope :is_active, ->{ where(status: true) }
	scope :is_not_tpv, ->{ where("role !=?", 'TPV') }
	scope :is_district_user, ->{ where("role =?", 'District User') }
	scope :is_status_not_null, ->{where("mobile_users.status is not null")}
	scope :filter_by_id, ->(data) { where("mobile_users.id =?", data) }
	scope :filter_by_tehsil_id, ->(data) { joins(:tehsils).where("tehsils.id =?", data) }
	scope :filter_by_tehsil_ids, ->(data) { joins(:tehsils).where("tehsils.id IN(?)", data) }
	scope :filter_by_tehsil, ->(data) { where("tehsils.id =?", data) }
	scope :filter_by_department, ->(data) { where("mobile_users.department_id = ?", data) }
	scope :filter_by_district_id, ->(data) { where("mobile_users.district_id = ?", data) }
	scope :filter_by_username, ->(data) { where("lower(mobile_users.username) like ?", "%#{data.try(:downcase)}%") }
	scope :filter_by_status, ->(data) { where("mobile_users.status is #{data}") }

	before_save :save_ids
	before_save :save_username_lower
	before_save :update_surveillance_vectory

	def update_surveillance_vectory
		if tag_category_ids.include?(6)
			self.is_surveillance = true
		else
			self.is_surveillance = false
		end
	end

	def save_username_lower
		self.username = self.username.try(:downcase)
	end
	def save_ids
		(self.district = District.find(district_id).try(:district_name)) rescue nil
	end

	def get_all_tehsil_ids
		tehsils.map(&:id)
	end
	def is_tpv_user?
		role == 'TPV'
	end
	def is_anti_dengue_user?
		role == 'Anti Dengue'
	end
	def is_district_user?
		role == 'DsApp District User'
	end
	def is_divisional_user?
		role == 'DsApp Divisional User'
	end
	def is_dengue_situation_app_user?
		is_district_user? || is_divisional_user?
	end
 end
