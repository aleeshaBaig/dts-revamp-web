class SurveillanceActivity < ApplicationRecord
    include SurveillanceActivityFilterable

    ## Scops - Filters
	scope :ascending, ->{order("surveillance_activities.created_at DESC")}
    
	scope :filter_by_tag_id, ->(data){data.present? ? (where("surveillance_activities.tag_id IN (?)", data) ) : where("true")}	
    scope :filter_by_uc, ->(data){ data.present? ? where("surveillance_activities.uc_id =?", data) : where("true")}
	scope :filter_by_tehsil_id, ->(data){data.present? ? where("surveillance_activities.tehsil_id =?", data) : where("true")}
	scope :filter_by_district_id, ->(data){data.present? ? where("surveillance_activities.district_id =?", data) : where("true")}
    scope :filter_by_datefrom, ->(data){data.present? ? (where("surveillance_activities.created_at >= ?", data) ) : where("true")}
	scope :filter_by_dateto, ->(data){data.present? ? (where("surveillance_activities.created_at <= ?", data) ) : where("true")}

    ## Enums
    enum activity_type: [:indoor, :outdoor]

    ## Relationships
    belongs_to :district, optional: true
    belongs_to :tehsil, optional: true
    belongs_to :uc, optional: true
    belongs_to :mobile_user, optional: true
	belongs_to :tag_category, optional: true
	belongs_to :tag, optional: true
    has_many :container_tags, :dependent => :destroy
    
    ## Validations
	validates :district_id, presence: {message: 'District should be required'}
    validates :tehsil_id, presence: {message: 'Tehsil should be required'}
    validates :uc_id, presence: {message: 'Uc should be required'}

    validates :mobile_user_id, presence: {message: 'User should be required'}
	validates :tag_category_id, presence: {message: 'Category should be required'}
	validates :tag_id, presence: {message: 'Tag should be required'}
    validates :lat, presence: {message: 'Latitude should be required'}
	validates :lng, presence: {message: 'Longitude should be required'}
	validates :activity_time, presence: {message: 'Activity Time should be required'}
    validates :name, presence: {message: 'Name should be required'}
    validates :shop_or_house, presence: {message: 'Shop/House should be required'}, if: Proc.new{|obj| obj.activity_type == 'indoor'}


    ## Remove Extra Spaces 
	auto_strip_attributes :name, :shop_or_house, :address, :uc_name, :tag_name, :tehsil_name, :uc_name, :tag_category_name, squish: true
    
    ## Callbacks
    before_create :get_province_id
    def get_province_id
        self.province_id = self.district.province.try(:id)
    end
end
