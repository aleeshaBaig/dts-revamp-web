class Bed < ApplicationRecord

    ## Scops
	
	scope :hospital_id, ->(hospital_id_v) { where("beds.hospital_id = ?", "#{hospital_id_v}") }
    scope :facility_type, ->(facility_type_v) { where("lower(hospitals.facility_type) like ?", "#{facility_type_v.try(:downcase)}%") }
	scope :category, ->(category_v) { where("lower(hospitals.category) like ?", "#{category_v.try(:downcase)}%") }
	scope :district_id, ->(district_id_v) { where("hospitals.district_id = ?", "#{district_id_v}") }


    scope :filter_by_hospital_id, ->(data){data.present? ? (where("beds.hospital_id =?", data) ) : where("true")}
    scope :filter_by_district_id, ->(data){data.present? ? (where("hospitals.district_id =?", data) ) : where("true")}
    scope :filter_by_category, ->(data){data.present? ? (where("hospitals.category =?", data) ) : where("true")}
    scope :filter_by_facility_type, ->(data){data.present? ? (where("hospitals.facility_type =?", data) ) : where("true")}
    scope :filter_by_hospital_category, ->(data){data.present? ? (where("hospitals.category =?", data) ) : where("true")}

    ## Relationship
    belongs_to :hospital, optional: true
    ## Validations
    validates :total_ward_beds, format: { with: /\A\d+\z/, message: "Total Ward Bed should be Numeric" },  numericality: { greater_than_or_equal_to: 0 , message: "This value should be greater than 0" }
    validates :total_hdu_beds, format: { with: /\A\d+\z/, message: "Total HDU Bed should be Numeric" } , numericality: { greater_than_or_equal_to: 0, message: "This value should be greater than 0" }

    validates :ward_beds_ramp_up, format: { with: /\A\d+\z/, message: "Ward Beds Ramp-Up should be Numeric" } , numericality: { greater_than_or_equal_to: 0, message: "This value should be greater than 0" }
    validates :hdu_beds_ramp_up, format: { with: /\A\d+\z/, message: "HDU Beds Ramp-Up should be Numeric" } , numericality: { greater_than_or_equal_to: 0, message: "This value should be greater than 0" }

    def is_update_columns?(params)
        # puts "=============total_ward_beds================#{params["total_ward_beds"]}, --- #{self.total_ward_beds}"
        # puts "=============total_hdu_beds================#{params["total_hdu_beds"]}, --- #{self.total_hdu_beds}"
        # puts "=============ward_beds_ramp_up================#{params["ward_beds_ramp_up"]}, --- #{self.ward_beds_ramp_up}"
        # puts "=============hdu_beds_ramp_up================#{params["hdu_beds_ramp_up"]}, --- #{self.hdu_beds_ramp_up}"
        self.total_ward_beds.to_i != params["total_ward_beds"].to_i || self.total_hdu_beds.to_i != params["total_hdu_beds"].to_i ||  self.ward_beds_ramp_up.to_i != params["ward_beds_ramp_up"].to_i || self.hdu_beds_ramp_up.to_i != params["hdu_beds_ramp_up"].to_i
    end
end
