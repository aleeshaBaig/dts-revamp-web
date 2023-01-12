class GpDengueUser < ApplicationRecord
	has_secure_password
    ## history save
	audited

    ## associations
    belongs_to :district, optional: true
    belongs_to :tehsil, optional: true
    belongs_to :uc, optional: true
    belongs_to :hospital, optional: true

    ## enums
    enum role: { "do": 0}

    ## validations
    validates :password, presence: true, length: { minimum: 6 }, on: :create
	validates :password, presence: true, length: { minimum: 6 }, if: Proc.new{|user| user.password.present?}

	validates :email, presence: {message: "Email can't be blank"}, uniqueness: {message: "Email should be unique"}
	validates :role, presence:{message: "Please Select Role"}
	validates :district_id, presence:{message: "Please Select District"}
	validates :tehsil_id, presence:{message: "Please Select any Tehsil"}
    # validates :hospital_id, presence:{message: "Please Select any Hospital"}
    validates :pmdc_number, presence: {message: "Pmdc No# can't be blank"}, uniqueness: {message: "Pmdc No# should be unique"}
    validates :contact_no, presence: {message: "Contact No# can't be blank"}, uniqueness: {message: "Contact No# should be unique"}
    validates :lat, presence: {message: "Latitude can't be blank"}, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, message: 'Latitude invalid'}
    validates :lng, presence: {message: "Longitude can't be blank"}, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, message: 'Longitude invalid' }


	## scopes
	default_scope {order("gp_dengue_users.id DESC")}
    scope :email, ->(data){where("gp_dengue_users.email =?", data)}
    scope :gp_name, ->(data){where("lower(gp_dengue_users.name) like?", "#{data.try(:downcase)}%")}
    scope :clinic_name, ->(data){where("lower(gp_dengue_users.clinic_name) like?", "#{data.try(:downcase)}%")}
    scope :pmdc_number, ->(data){where("lower(gp_dengue_users.pmdc_number) like?", "#{data.try(:downcase)}%")}
    scope :cnic, ->(data){where("gp_dengue_users.cnic =?", data)}
    scope :district_id, ->(data){where("gp_dengue_users.district_id =?", data)}
    scope :tehsil_id, ->(data){where("gp_dengue_users.tehsil_id =?", data)}
    scope :uc_id, ->(data){where("gp_dengue_users.uc_id =?", data)}
    scope :hospital_id, ->(data){where("gp_dengue_users.hospital_id =?", data)}
    scope :contact_no, ->(data){where("gp_dengue_users.contact_no =?", data)}
	scope :datefrom, ->(data){data.present? ? (where("gp_dengue_users.created_at::DATE >= ?", Time.parse("#{data}").to_date) ) : where("true")}
	scope :dateto, ->(data){data.present? ? (where("gp_dengue_users.created_at::DATE <= ?", Time.parse("#{data}").to_date) ) : where("true")}


    ## trim white spaces
    auto_strip_attributes :address, :city_name, squish: true


    ## call backs
    before_save :city_names
    def city_names
        self.city_name = self.city_name.try(:strip).try(:titleize)
    end
end
