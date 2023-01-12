class Slideshow < ApplicationRecord
	include SlideshowFilterable

	## scops
	scope :ascending, ->{order("slideshows.created_at DESC")}
	scope :filter_by_department_id, ->(data){where("slideshows.department_id =?", data.to_i)}
	scope :filter_by_name, ->(data){where("lower(slideshows.name) like ?", "%#{data.try(:downcase)}%")}
	scope :filter_by_username, ->(data){where("slideshows.user_id =?", Slideshow.find_username(data))}
	scope :filter_by_from, ->(data){where("slideshows.created_at >=?", Time.parse("#{data.to_datetime}").beginning_of_day )}
	scope :filter_by_to, ->(data){where("slideshows.created_at <=?", Time.parse("#{data.to_datetime}").end_of_day )}

	## associations
	has_one :picture, :as => :pictureable
	# belongs_to :user, optional: true

	belongs_to :user, optional: true
	belongs_to :department, optional: true

	## enums
	enum activity_type: %w(patient simple)
	
	## validations
	validates :name, presence: {message: 'Name is required.'}
	validates :activity_ids, presence: {message: 'Please Check any Activity Images'}

	## remove extra spaces 
	auto_strip_attributes :name

	before_save :titleize_data
	def titleize_data
		self.name = self.name.try(:titleize)
	end

	def self.find_username(username)
		user_id = -1
		user = User.select("username, id").where("lower(username) =?", "#{username.try(:downcase)}").last
		if user.present?
			user_id = user.id
		end
		return user_id
	end
end
