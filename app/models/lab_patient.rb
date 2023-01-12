class LabPatient < ApplicationRecord
	include LabPatientFilterable
	## history save
	audited
	## associations
	belongs_to :lab
	has_one :patient
	belongs_to :g_district, class_name: "District", primary_key: "id", foreign_key: 'district_id'
	belongs_to :g_perm_district, class_name: "District", primary_key: "id", foreign_key: 'perm_district_id'
	belongs_to :g_workplc_district, class_name: "District", optional: true, primary_key: "id", foreign_key: 'workplc_district_id'

	enum provisional_diagnosis: {  "Probable": 0, "Confirmed": 1}
	enum transfer_type: { "Not Transferred": 0, "Lab To Hospital": 1, 'DPC': 2}
	# enum provisional_diagnosis: {  "Probable": 1, "Suspected": 2}

	scope :filter_by_cnic, ->(data){where("cnic like ?", "%#{data}%")}
	scope :filter_by_transfer_status, ->(data){where(transfer_type: data)}
	scope :filter_by_p_name, ->(data){where("lower(p_name) like ?", "%#{data.try(:downcase)}%")}
	scope :filter_by_district_id, ->(data){data.present? ? where("district_id =?", data) : where("true")}
	scope :filter_by_tehsil_id, ->(data){where("tehsil_id =?", data)}
	scope :filter_by_uc_id, ->(data){where("uc_id =?", data)}
	scope :filter_by_lab_id, ->(data){data.present? ? (where("lab_id =?", data) ) : where("true")}
	scope :filter_by_prov_diagnosis, ->(data){where("provisional_diagnosis =?", data)}
	scope :filter_by_p_id, ->(data){where("id =?", data)}
	scope :filter_by_d_from, ->(data){data.present? ? (where("created_at >= ?", data) ) : where("true")}
	scope :filter_by_d_to, ->(data){data.present? ? (where("created_at <= ?", data) ) : where("true")}

	#Validations
	validates :p_name, presence: {message: 'Please enter patient name'}
	validates :fh_name, presence: {message: "Please enter guardian's name"}
	validates :age, presence: {message: "Please enter age"}, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 150 }
	validates :reporting_date, presence: {message: "Please enter Reporting Date"}
	# validates :hct_first_reading, format: { with: /(^[0-9]{1,5}$)/, message: "Please enter correct HCT First Reading"}
	# validates :wbc_first_reading, format: { with: /(^[0-9]{1,5}$)/, message: "Please enter correct WBC First Reading"}
	# validates :platelet_first_reading, format: { with: /(^[0-9]{1,5}$)/, message: "Please enter correct Platelets First Reading"}
	
	validates :hct_first_reading, presence: {message: "Please enter HCT first reading"}, format: { with: /(^[0-9]{1,5}$)/, message: "Please enter correct HCT First Reading"}, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}
	validates :wbc_first_reading, presence: {message: "Please enter WBC first reading"}, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}
	validates :platelet_first_reading, presence: {message: "Please enter platelet first reading"}, format: { with: /(^[0-9]{1,6}$)/, message: "Please enter correct Platelets First Reading"}, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed" }

	validates :ns_1, presence: {message: "Please enter NS1"}, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}
	validates :pcr, presence: {message: "Please enter PCR"}, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}
	validates :igm, presence: {message: "Please enter IGM"}, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}
	validates :igg, presence: {message: "Please enter IGG"}, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}



	validates :gender, presence: {message: 'Please select gender'}
	validates :cnic, presence: {message: 'Please enter CNIC'}, format: { with: /(^[0-9]{5}-[0-9]{7}-[0-9]$)/, message: "Please enter correct CNIC"}, uniqueness: {message: "CNIC already taken"}
	validates :cnic_type, presence: {message: "Please enter CNIC Type"}
	validates :contact_no, presence: {message: "Please enter Contact number"}, format: { with: /(^[0-9]{11}$)/, message: "Please enter correct Contact No"}
	# validates :other_contact_no, format: { with: /(^[0-9]{11}$)/, message: "Please enter correct Guardian's Contact No"}

	validates :address, presence: {message: "Please enter patient's address"}
	validates :district_id, presence: {message: "Please enter patient's district"}
	validates :tehsil_id, presence: {message: "Please enter patient's tehsil"}
	# validates :uc_id, presence: {message: "Please enter patient's union council"}

	validates :perm_address, presence: {message: "Please enter permanent address"}
	validates :perm_district_id, presence: {message: "Please enter permanent district"}
	validates :perm_tehsil_id, presence: {message: "Please enter permanent tehsil"}
	# validates :perm_uc_id, presence: {message: "Please enter permanent union council"}

	# validates :workplc_address, presence: {message: "Please enter workplace address"}
	# validates :workplc_district_id, presence: {message: "Please enter workplace district"}
	# validates :workplc_tehsil_id, presence: {message: "Please enter workplace tehsil"}
	# validates :workplc_uc_id, presence: {message: "Please enter workplace union council"}
	# validates :comments, presence: {message: "Please enter comments"}
	validates :provisional_diagnosis, :inclusion => {:in => LabPatient.provisional_diagnoses.keys, message: "Please select provisional diagnosis"}
	
	## auto spaces removed
	auto_strip_attributes :address, :perm_address, :workplc_address, :p_name, :fh_name, squish: true

	## Hooks
	before_save :downcase_fields
	before_save :get_lab_name
	before_save :get_district_name
	before_save :get_tehsil_name
	before_save :get_uc_name
	before_save :provisional_diagnosis_confirmed, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}
	def provisional_diagnosis_confirmed
		self.confirmation_date = Time.now.to_datetime
	end

	## hooks methods
	def downcase_fields
    	self.p_name.try(:titleize)
    	self.fh_name.try(:titleize)
  	end

  ## saved lab_name
	def get_lab_name
	 (self.lab_name = Lab.find(lab_id).lab_name) if lab_id.present?
	end

	def get_district_name
		(self.district = District.find(district_id).district_name) if district_id.present?
		(self.perm_district = District.find(perm_district_id).district_name) if perm_district_id.present?
		(self.workplc_district = District.find(workplc_district_id).district_name) if workplc_district_id.present?
	end

	def get_tehsil_name
		(self.tehsil = Tehsil.find(tehsil_id).tehsil_name) if tehsil_id.present?
		(self.perm_tehsil = Tehsil.find(perm_tehsil_id).tehsil_name) if perm_tehsil_id.present?
		(self.workplc_tehsil = Tehsil.find(workplc_tehsil_id).tehsil_name) if workplc_tehsil_id.present?
	end

	def get_uc_name
		(self.uc = Uc.find(uc_id).uc_name) if uc_id.present?
		(self.perm_uc = Uc.find(perm_uc_id).uc_name) if perm_uc_id.present?
		(self.workplc_uc = Uc.find(workplc_uc_id).uc_name) if workplc_uc_id.present?
	end
	def set_patient_attributes(patient)
		self.p_name = patient.patient_name
		self.fh_name = patient.fh_name
		self.age = patient.age
		self.month = patient.age_month
		self.gender = patient.gender
		self.cnic_type = patient.cnic_relation
		self.cnic = patient.cnic
		self.contact_no = patient.patient_contact
		self.other_contact_no = patient.relation_contact
		self.district_id = patient.district_id
		self.district = patient.district

		self.tehsil_id = patient.tehsil_id
		self.tehsil = patient.tehsil

		self.uc_id = patient.uc_id
		self.uc = patient.uc

		self.address = patient.address
		self.provisional_diagnosis = patient.provisional_diagnosis

		## perm address
		self.perm_address = patient.permanent_address
		self.perm_district = patient.permanent_district
		self.perm_district_id = patient.permanent_district_id
		self.perm_tehsil = patient.permanent_tehsil
		self.perm_tehsil_id = patient.permanent_tehsil_id
		self.perm_uc = patient.permanent_uc
		self.perm_uc_id = patient.permanent_uc_id

		## workplace        
		self.workplc_address = patient.workplace_address
		self.workplc_district = patient.workplace_district
		self.workplc_district_id = patient.workplace_district_id
		self.workplc_tehsil = patient.workplace_tehsil
		self.workplc_tehsil_id = patient.workplace_tehsil_id
		self.workplc_uc = patient.workplace_uc
		self.workplc_uc_id = patient.workplace_uc_id
		self.reporting_date = patient.reporting_date
		self.confirmation_date = patient.confirmation_date
	end

	private
	


	validate :incorrect_hct_first_reading_date
	validate :incorrect_hct_second_reading_date
	validate :incorrect_hct_third_reading_date

	def incorrect_hct_first_reading_date
		errors.add(:hct_first_reading_date, "Incorrect HCT first Reading Date") if hct_first_reading_date.present? and (hct_first_reading_date.to_date  > Time.now.to_date)
	end
	def incorrect_hct_second_reading_date
		errors.add(:hct_second_reading_date, "Incorrect HCT second Reading Date") if hct_second_reading_date.present? and (hct_second_reading_date.to_date > Time.now.to_date)
	end
	def incorrect_hct_third_reading_date
		errors.add(:hct_third_reading_date, "Incorrect HCT third Reading Date") if hct_third_reading_date.present? and (hct_third_reading_date.to_date > Time.now.to_date)
	end

	validate :incorrect_wbc_first_reading_date
	validate :incorrect_wbc_second_reading_date
	validate :incorrect_wbc_third_reading_date

	def incorrect_wbc_first_reading_date
		errors.add(:wbc_first_reading_date, "Incorrect WBC first Reading Date") if wbc_first_reading_date.present? and wbc_first_reading_date.to_date > Time.now.to_date
	end
	def incorrect_wbc_second_reading_date
		errors.add(:wbc_second_reading_date, "Incorrect WBC second Reading Date") if wbc_second_reading_date.present? and wbc_second_reading_date.to_date > Time.now.to_date
	end
	def incorrect_wbc_third_reading_date
		errors.add(:wbc_third_reading_date, "Incorrect WBC third Reading Date") if wbc_third_reading_date.present? and wbc_third_reading_date.to_date > Time.now.to_date
	end

	validate :incorrect_platelet_first_reading_date
	validate :incorrect_platelet_second_reading_date
	validate :incorrect_platelet_third_reading_date

	def incorrect_platelet_first_reading_date
		errors.add(:platelet_first_reading_date, "Incorrect Platelet first Reading Date") if platelet_first_reading_date.present? and platelet_first_reading_date.to_date > Time.now.to_date
	end
	def incorrect_platelet_second_reading_date
		errors.add(:platelet_second_reading_date, "Incorrect Platelet second Reading Date") if platelet_second_reading_date.present? and platelet_second_reading_date.to_date > Time.now.to_date
	end
	def incorrect_platelet_third_reading_date
		errors.add(:platelet_third_reading_date, "Incorrect Platelet third Reading Date") if platelet_third_reading_date.present? and platelet_third_reading_date.to_date > Time.now.to_date
	end

	validate :test_reports_wrt_provisional_diagnosis

	def test_reports_wrt_provisional_diagnosis
		if provisional_diagnosis == "Confirmed" and (ns_1 != "Positive" and igm != "Positive" and pcr != "Positive")
			errors.add(:provisional_diagnosis, "Provisional Diagnosis can not be confirmed if none of the results are positive")
		elsif provisional_diagnosis == "Probable" and (ns_1 == "Positive" or igm == "Positive" or pcr == "Positive")
			errors.add(:provisional_diagnosis, "Provisional Diagnosis can not be probable if any of the results is positive")
		end
	end
end
