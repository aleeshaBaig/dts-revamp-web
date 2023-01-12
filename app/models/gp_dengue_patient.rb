class GpDenguePatient < ApplicationRecord
    ## history save
	audited

    ## enums
    enum provisional_diagnosis: { "Probable": 1, "Suspected": 2, "Confirmed": 3}
    enum reffer_type: { "Lab": 0, "Hospital": 1}
    enum gender: { "Male": 0, "Female": 1, "Others": 2}
    ## associations
    belongs_to :hospital, optional: true
    # belongs_to :lab, optional: true
    belongs_to :gp_dengue_user


    has_one :current_address, :dependent => :destroy
    has_one :picture, :as => :pictureable, :dependent => :destroy
    # has_one :workplace_address, :dependent => :destroy
    # has_one :permanent_address, :dependent => :destroy
    # has_one :gp_symptom, :dependent => :destroy
    # has_one :gp_lab_diagnostice, :dependent => :destroy
    # has_one :gp_lab_result, :dependent => :destroy

    has_associated_audits
    ## validations
    validates :patient_name, presence: {message: "Patient Name can't be blank"}
    # validates :fh_name, presence: {message: "S/O, D/O, W/O can't be blank"}
    # validates :age, presence: {message: "Please Select Age"}
	validates :gender, presence: {message: "Please Select Gender"}
    # validates :age_month, presence: {message: "Please Select Age in Months"}, if: Proc.new{|obj| obj.age == 0}
    # validates :cnic, presence: {message: 'Please enter CNIC'}, uniqueness: {message: "CNIC already taken"}
    validates :contact_no, presence: {message: "Please enter Contact Number"}
    validates :provisional_diagnosis, presence: {message: "Provisional Diagnosis not exist" }
    validates :lat, presence: {message: "Latitude can't be blank"}, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, message: 'Latitude invalid'}
    validates :lng, presence: {message: "Longitude can't be blank"}, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, message: 'Longitude invalid' }


	## scopes
	default_scope {order("gp_dengue_patients.id DESC")}
	scope :patient_id, ->(data){where("gp_dengue_patients.id =?", data)}
    scope :patient_name, ->(data){where("lower(gp_dengue_patients.patient_name) like?", "#{data.try(:downcase)}%")}
    scope :gender, ->(data){where("gp_dengue_patients.gender =?", genders["#{data}"])}
    scope :cnic, ->(data){where("gp_dengue_patients.cnic =?", data)}
    scope :province_id, ->(data){where("current_addresses.province_id =?", data)}
    scope :district_id, ->(data){where("current_addresses.district_id =?", data)}
    scope :tehsil_id, ->(data){where("current_addresses.tehsil_id =?", data)}
    scope :uc_id, ->(data){where("current_addresses.uc_id =?", data)}
    scope :hospital_id, ->(data){where("gp_dengue_patients.hospital_id =?", data)}
    scope :contact_no, ->(data){where("gp_dengue_patients.contact_no =?", data)}
    scope :entered_by, ->(data){where("lower(gp_dengue_users.name) like ?", "%#{data.try(:downcase)}%" )}
    scope :provisional_diagnosis, ->(data){where("gp_dengue_patients.provisional_diagnosis =?", provisional_diagnoses["#{data}"])}
	scope :datefrom, ->(data){data.present? ? (where("gp_dengue_patients.activity_time >= ?", data) ) : where("true")}
	scope :dateto, ->(data){data.present? ? (where("gp_dengue_patients.activity_time <= ?", data) ) : where("true")}    

    ### callbacks functions
    def save_picture(m_before_picture = nil, m_after_picture = nil)
		if create_picture(before_picture: m_before_picture, after_picture: m_after_picture)
			return reload_picture
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
