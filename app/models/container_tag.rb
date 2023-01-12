class ContainerTag < ApplicationRecord
  include ContainerTagFilterable

  ## Scops - Filters
  scope :ascending, ->{order("container_tags.created_at DESC")}
  
  scope :filter_by_activity_type, ->(data){data.present? ? (where("container_tags.activity_type =?", ContainerTag.activity_types[data]) ) : where("true")}	
  scope :filter_by_uc, ->(data){ data.present? ? where("container_tags.uc_id =?", data) : where("true")}
  scope :filter_by_tehsil_id, ->(data){data.present? ? where("container_tags.tehsil_id =?", data) : where("true")}
  scope :filter_by_district_id, ->(data){data.present? ? where("container_tags.district_id =?", data) : where("true")}
  scope :filter_by_datefrom, ->(data){data.present? ? (where("container_tags.created_at >= ?", data) ) : where("true")}
  scope :filter_by_dateto, ->(data){data.present? ? (where("container_tags.created_at <= ?", data) ) : where("true")}

  ## Enums
  enum activity_type: [:indoor, :outdoor]

  ## Relationships
  belongs_to :district, optional: true
  belongs_to :tehsil, optional: true
  belongs_to :uc, optional: true
  belongs_to :mobile_user, optional: true
  belongs_to :surveillance_tag, optional: true
  belongs_to :surveillance_activity

  ## Validations
  validates :district_id, presence: {message: 'District should be required'}
  validates :tehsil_id, presence: {message: 'Tehsil should be required'}
  validates :uc_id, presence: {message: 'Uc should be required'}

  validates :mobile_user_id, presence: {message: 'User should be required'}
  validates :surveillance_tag_id, presence: {message: 'Container Tag should be required'}

  
    ## Remove Extra Spaces 
    auto_strip_attributes :uc_name, :tehsil_name, :uc_name, squish: true
    
    ## Callbacks
    before_create :get_province_id
    def get_province_id
        self.province_id = self.district.province.try(:id)
    end
end
