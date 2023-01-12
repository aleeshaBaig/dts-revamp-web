class Patient < ApplicationRecord
	include PatientFilterable
	## history save
	audited
	## soft delete
	acts_as_paranoid
	## associations
	has_many :activities, class_name: 'PatientActivity'
	has_many :test_logs
	has_one :lab_result, :dependent => :destroy
	accepts_nested_attributes_for :lab_result

	belongs_to :user, optional: true
	belongs_to :lab_patient, optional: true
	belongs_to :admitted_hospital, class_name: 'Hospital', primary_key: "id", foreign_key: 'hospital_id', optional: true

	belongs_to :g_district, class_name: "District", primary_key: "id", foreign_key: 'district_id', optional: true
	belongs_to :g_perm_district, class_name: "District", primary_key: "id", foreign_key: 'permanent_district_id', optional: true
	belongs_to :g_workplc_district, class_name: "District", primary_key: "id", foreign_key: 'workplace_district_id', optional: true

	belongs_to :g_perm_uc, class_name: "Uc", primary_key: "id", foreign_key: 'permanent_uc_id', optional: true
	
	belongs_to :updated_by, class_name: "User", primary_key: "id", foreign_key: 'updated_id', optional: true
	belongs_to :from_lab, class_name: "User", primary_key: "id", foreign_key: 'lab_user_id', optional: true
	belongs_to :from_hospital, class_name: "User", primary_key: "id", foreign_key: 'user_id', optional: true
	belongs_to :confirmation_by, class_name: "User", primary_key: "id", foreign_key: 'confirmation_id', optional: true

	enum provisional_diagnosis: { "Non-Dengue": 0, "Probable": 1, "Suspected": 2, "Confirmed": 3}
	enum patient_status: { "Closed": 0, "In Process": 1, "Lab": 2}
	enum entered_by: { "By Hospital": 0, "By Lab": 1}
	enum confirmation_role: { "Confirmed by Hospital": 0, "Confirmed by Lab": 1}
	enum patient_outcome: { "Admitted": 0, "Death": 1, "Discharged": 2, "LAMA": 3, "Outpatient": 4}
	enum patient_condition: { "Critical": 0, "Stable": 1}
	enum transfer_type: { "Not Transferred": 0, "Lab To Hospital": 1, 'DPC': 2}
	enum p_search_type: { "CNIC": 0, "Passport": 1 }
	


	## scopes
	scope :ascending, ->{order("created_at DESC")}
	
	#	<<<< Ability CanCan >>>
	scope :cannot_edit, -> {where("patients.patient_outcome =?", 'Death')}
	scope :in_process_status, -> {where("patients.patient_status =?", 'In Process')}
	scope :not_in_process_status, -> {where("patients.patient_status !=?", 'Closed')}
	## 	<<< End Ability Cancan >>>
	scope :get_patient_activities_prov_diag, ->{where(provisional_diagnosis: ["Probable", "Suspected", "Confirmed"])}
	scope :get_patient_activities_non_dengue, ->{where("provisional_diagnosis !=?", 0)}
	scope :unreleased, -> {where("patients.is_released is not true")}
	scope :released, -> {where("patients.is_released is true")}
	scope :filter_by_cnic, ->(data){where("cnic =?", data)}
	scope :filter_by_patient_contact, ->(data){where("patient_contact =?", data)}
	
	scope :filter_by_passport, ->(data){where("passport =?", data.try(:downcase))}
	scope :is_beds_patients, ->{ unreleased.where(patient_outcome: 'Admitted').where("patients.entry_source is null or patients.entry_source =?", nil).where(patient_status: "In Process")}
	scope :filter_by_patient_name, ->(data){where("lower(patient_name) like ?", "%#{data.try(:downcase)}%")}
	scope :filter_by_tehsil_id, ->(data){data.present? ? (where("tehsil_id =?", data)) : where("true")}
	scope :filter_by_tehsil_ids, ->(data){data.present? ? (where("tehsil_id IN(?)", data)) : where("true")}

	## Match by Labs Apis Patient Name and Contact as Uniq

	scope :is_uniq_p_name, ->(data){data.present? ? (where("TRIM(lower(patient_name)) =?", data.try(:downcase).try(:strip))) : where("true")}
	scope :is_uniq_p_contact, ->(data){data.present? ? (where("replace(patient_contact, '-', '') =?", data.try(:scan, /\d/).try(:join))) : where("true") }

	scope :filter_by_province_id, ->(data){data.present? ? (where("patients.province_id =?", data) ) : where("true")}
	scope :filter_by_district_id, ->(data){data.present? ? (where("patients.district_id =?", data) ) : where("true")}
	scope :filter_by_hospital_id, ->(data){data.present? ? (where("patients.hospital_id =?", data) ) : where("true")}
	scope :filter_by_outcome, ->(data){where("patient_outcome =?", Patient.patient_outcomes[data])}
	scope :filter_by_condition, ->(data){where("patient_condition =?", Patient.patient_conditions[data])}
	scope :filter_by_patient_status, ->(data){where("patient_status =?", Patient.patient_statuses[data])}
	scope :filter_by_prov_diagnosis, ->(data){where("provisional_diagnosis =?", Patient.provisional_diagnoses[data])}

	scope :filter_by_confirm_by, ->(data){where("confirmation_role =?", Patient.confirmation_roles[data])}

	scope :filter_by_uc_id, ->(data){data.present? ? (where("uc_id =?", data) ) : where("true")}
	scope :filter_by_p_id, ->(data){where("patients.id =?", data)}
	scope :filter_by_month, ->(data){data.present? ? (where("extract(month from patients.created_at) = ?", data) ) : where("true")}
	scope :filter_by_year, ->(data){data.present? ? (where("extract(year from patients.created_at) = ?", data) ) : where("true")}
	scope :filter_by_d_from, ->(data){data.present? ? (where("patients.created_at::DATE >= ?", Time.parse("#{data}").to_date) ) : where("true")}
	scope :filter_by_d_to, ->(data){data.present? ? (where("patients.created_at::DATE <= ?", Time.parse("#{data}").to_date) ) : where("true")}

	scope :filter_by_datefrom, ->(data){data.present? ? (where("patients.created_at >= ?", data) ) : where("true")}
	scope :filter_by_dateto, ->(data){data.present? ? (where("patients.created_at <= ?", data) ) : where("true")}

	# scope :filter_by_confirm_datefrom, ->(data){data.present? ? (where("patients.confirmation_date >= ?", data) ) : where("true")}
	# scope :filter_by_confirm_dateto, ->(data){data.present? ? (where("patients.confirmation_date <= ?", data) ) : where("true")}
	scope :filter_by_confirm_datefrom, ->(data){where("true")}
	scope :filter_by_confirm_dateto, ->(data){where("true")}


	scope :filter_by_from, ->(data){data.present? ? (where("patients.created_at::DATE >=?", Time.parse("#{data}").to_date) ) : where("true")}
	scope :filter_by_to, ->(data){data.present? ? (where("patients.created_at::DATE <=?", Time.parse("#{data}").to_date) ) : where("true")}
	scope :filter_by_facility_type, ->(data){data.present? ? (joins(:admitted_hospital).where("hospitals.facility_type = ?", data)) : where("true")}
	scope :filter_by_hospital_category, ->(data){data.present? ? (joins(:admitted_hospital).where("hospitals.category = ?", data)) : where("true")}

	scope :phc_patients_joins, ->{includes(:lab_patient, :lab_result, :from_lab, :user, admitted_hospital: :district)}
	## scopes
	scope :get_tehsils, ->(tehsils){where("patients.tehsil_id IN(?)", tehsils)}
	## RESIDENCE
	scope :is_residence_tagged, -> { where("patients.residence_tagged is true") }
	scope :is_residence_untagged, -> { where("patients.residence_tagged is false") }
	## WORKPRELACE
	scope :get_workplace_tehsil, ->(tehsils){where("patients.workplace_tehsil_id IN(?)", tehsils)}
	scope :is_workplace_tagged, ->{where("patients.workplace_tagged is true")}
	scope :is_workplace_untagged, ->{where("patients.workplace_tagged is false")}
	## PERMAANEN TEHSIL ID
	scope :get_permanent_tehsil, ->(tehsils){where("patients.permanent_tehsil_id IN(?)", tehsils)}
	scope :is_permanent_residence_tagged, ->{where("patients.permanent_residence_tagged is true")}
	scope :is_permanent_residence_untagged, ->{where("patients.permanent_residence_tagged is false")}
	## Patient Data Api Mobile
	scope :select_patient_data, ->{select("id, patient_name, cnic, cnic_relation, patient_contact, relation_contact, provisional_diagnosis, address, uc, uc_id, tehsil, tehsil_id, workplace_address, workplace_uc, workplace_uc_id, workplace_tehsil, workplace_tehsil_id, permanent_address, permanent_uc, permanent_uc_id, permanent_tehsil, permanent_tehsil_id, residence_count, workplace_count, permanent_count, permanent_residence_tagged, workplace_tagged, residence_tagged")}
    scope :untagged_patient_data_where,->(data){where("(tehsil_id IN(?) and (residence_tagged is not true)) OR (workplace_tehsil_id IN(?) and (workplace_tagged is not true)) OR (permanent_tehsil_id IN(?) and (permanent_residence_tagged is not true))", data, data, data)}

	## Un Tagged Patients
	scope :untagged_residence_tagged, ->(data){where("residence_tagged is not true and tehsil_id #{inOrEqualQuery(data)}", data)}
	scope :untagged_workplace_tagged, ->(data){where("workplace_tagged is not true and workplace_tehsil_id #{inOrEqualQuery(data)}", data)}
	scope :untagged_permanent_residence_tagged, ->(data){where("permanent_residence_tagged is not true and permanent_tehsil_id #{inOrEqualQuery(data)}", data)}

	## Tagged patients
	scope :tagged_residence_tagged, ->(data){where("residence_tagged is true and tehsil_id #{inOrEqualQuery(data)}", data)}
	scope :tagged_workplace_tagged, ->(data){where("workplace_tagged is true and workplace_tehsil_id #{inOrEqualQuery(data)}", data)}
	scope :tagged_permanent_residence_tagged, ->(data){where("permanent_residence_tagged is true and permanent_tehsil_id #{inOrEqualQuery(data)}", data)}

	def self.inOrEqualQuery(data) 
		data.size > 1 ? "IN(?)" : "=?"
	end

	#Validations
	validates :hospital_id, presence: {message: 'Please select hospital'}
	validates :patient_name, presence: {message: 'Please enter patient name'}
	validates :fh_name, presence: {message: "Please enter guardian's name"}
	validates :age, presence: {message: "Please enter age"}
	validates :age_month, presence: {message: "Please enter age in months"}, if: Proc.new{|obj| obj.age == 0}
	validates :gender, presence: {message: 'Please select gender'}
	# validates :relation, presence: {message: 'Please select relation'}
	validates :cnic, presence: {message: 'Please enter CNIC'}, format: { with: /(^[0-9]{5}-[0-9]{7}-[0-9]$)/, message: 'Please Enter Correct Format of CNIC'}, if: Proc.new{|obj| obj.p_search_type == 'CNIC'}
	validates :passport, presence: {message: 'Please enter Passport'}, length: {minimum: 9, maximum: 9, message: 'Passport Length should be 9 characters'}, if: Proc.new{|obj| obj.p_search_type == 'Passport'}
	# validates :cnic_relation, presence: {message: "Please enter Guardian's Relation"}
	validates :patient_contact, presence: {message: "Please enter patient's contact number"}
	# validates :relation_contact, presence: {message: "Please enter guardian's contact number"}

	validates :address, presence: {message: "Please enter patient's address"}
	validates :district_id, presence: {message: "Please enter patient's district"}
	validates :tehsil_id, presence: {message: "Please enter patient's tehsil"}
	# validates :uc_id, presence: {message: "Please enter patient's union council"}

	validates :permanent_address, presence: {message: "Please enter permanent address"}
	validates :permanent_district_id, presence: {message: "Please enter permanent district"}
	validates :permanent_tehsil_id, presence: {message: "Please enter permanent tehsil"}
	# validates :permanent_uc_id, presence: {message: "Please enter permanent union council"}
	validates :reporting_date, presence: {message: "Please enter Reporting Date"}

	# validates :workplace_address, presence: {message: "Please enter workplace address"}
	# validates :workplace_district_id, presence: {message: "Please enter workplace district"}
	# validates :workplace_tehsil_id, presence: {message: "Please enter workplace tehsil"}
	# validates :workplace_uc_id, presence: {message: "Please enter workplace union council"}

	# validates :fever, presence: {message: "Please select fever ( > 2 and < 10 days duration)"}
	
	validates :previous_dengue_fever, inclusion: {in: [true, false], message: "Please select previous H/O dengue fever"}, if: Proc.new{|obj| is_hospital_user?(obj) }
	validates :associated_symptom, inclusion: {in: [true, false], message: "Please select associated symptom"}, if: Proc.new{|obj| is_hospital_user?(obj) }
	validates :provisional_diagnosis, presence: {message: "Please select provisional diagnosis"}
	
	# validates :patient_status, presence: {message: "Please select patient status"}
	validates :patient_outcome, presence: {message: "Please select patient outcome"}, if: Proc.new{|obj| is_hospital_user?(obj)}
	# validates :patient_condition, presence: {message: "Please select patient condition"}
	validates :comments, presence: {message: "Please enter comments"}
	validates :death_date, presence: {message: "Please enter death date"}, if: Proc.new{|obj| obj.patient_outcome == "Death"}
	
	validate :lab_result_hospital_wise_user, if: Proc.new{|obj| is_hospital_user?(obj)}
	validate :lab_result_lab_wise_user, if: Proc.new{|obj| is_lab_user?(obj)}
	validate :patient_name_and_contact_should_unique

	## callback functions
	before_save :district_tehsil_names
	def district_tehsil_names
		#Current Section
		self.district = (District.find(self.district_id).district_name rescue nil) if self.district_id.present?
		self.tehsil = (Tehsil.find(self.tehsil_id).tehsil_name rescue nil) if self.tehsil_id.present?
		self.uc = (Uc.find(self.uc_id).uc_name rescue nil) if self.uc_id.present?
		
		#Permanent Section
		self.permanent_district = (District.find(self.permanent_district_id).district_name rescue nil) if self.permanent_district_id.present?
		self.permanent_tehsil = (Tehsil.find(self.permanent_tehsil_id).tehsil_name rescue nil) if self.permanent_tehsil_id.present?
		self.permanent_uc = (Uc.find(self.permanent_uc_id).uc_name rescue nil) if self.permanent_uc_id.present?
	
		#Workplace Section
		self.workplace_district = (District.find(self.workplace_district_id).district_name rescue nil) if self.workplace_district_id.present?
		self.workplace_tehsil = (Tehsil.find(self.workplace_tehsil_id).tehsil_name rescue nil) if self.workplace_tehsil_id.present?
		self.workplace_uc = (Uc.find(self.workplace_uc_id).uc_name rescue nil) if self.workplace_uc_id.present?
	end
	
	def lab_result_hospital_wise_user
		# puts "p1 = #{self.provisional_diagnosis}"
		# puts "p2 = #{lab_result.ns1}"
		# puts "p3 = #{lab_result.igm}"
		# puts "p4 = #{lab_result.pcr}"
		# puts "p5 = #{lab_result.igg}"

		if lab_result.present?
			if provisional_diagnosis == "Confirmed" and (lab_result.ns1 != "Positive" and lab_result.igm != "Positive" and lab_result.pcr != "Positive" and lab_result.igg != "Positive")
				errors.add(:provisional_diagnosis, "Provisional Diagnosis can not be confirmed if none of the results are positive")
			elsif provisional_diagnosis == "Probable" and (lab_result.ns1 == "Positive" or lab_result.igm == "Positive" or lab_result.pcr == "Positive")
				errors.add(:provisional_diagnosis, "Provisional Diagnosis can not be probable if any of the results is positive")
			elsif lab_result.warning_signs.nil? and provisional_diagnosis == "Confirmed" and user_id.present?
				lab_result.errors.add(:warning_signs, "Please select presence of warning signs")
			end
		else
			errors.add(:provisional_diagnosis, "Please select Lab and Diagnostic Information")
		end
	end
	def lab_result_lab_wise_user
		# puts "p1 = #{self.provisional_diagnosis}"
		# puts "p2 = #{lab_result.ns1}"
		# puts "p3 = #{lab_result.igm}"
		# puts "p4 = #{lab_result.pcr}"
		# puts "p5 = #{lab_result.igg}"

		if lab_result.present?
			if provisional_diagnosis == "Confirmed" and (lab_result.ns1 != "Positive" and lab_result.igm != "Positive" and lab_result.pcr != "Positive" and lab_result.igg != "Positive")
				errors.add(:provisional_diagnosis, "Provisional Diagnosis can not be confirmed if none of the results are positive")
			elsif provisional_diagnosis == "Probable" and (lab_result.ns1 == "Positive" or lab_result.igm == "Positive" or lab_result.pcr == "Positive")
				errors.add(:provisional_diagnosis, "Provisional Diagnosis can not be probable if any of the results is positive")
			elsif lab_result.warning_signs.nil? and provisional_diagnosis == "Confirmed" and user_id.present?
				lab_result.errors.add(:warning_signs, "Please select presence of warning signs")
			end
			# elsif provisional_diagnosis == "Confirmed" and (lab_result.igg == '' or lab_result.igg == nil or lab_result.blank?)
			# 	lab_result.errors.add(:igg, "Please enter IGG")
		else
			errors.add(:provisional_diagnosis, "Please select Lab and Diagnostic Information")
		end
	end
	

	## remove extra spaces 
	auto_strip_attributes :comments, :passport, squish: true

	before_save :provisional_diagnosis_confirmed, if: Proc.new{|obj| obj.provisional_diagnosis == "Confirmed"}
	before_save :update_patient_status, if: Proc.new{|obj| obj.patient_outcome.present? and is_hospital_user?(obj)}

	def update_patient_status
		if ['Admitted', 'Outpatient'].include?(self.patient_outcome)
			self.patient_status = 'In Process'
			self.is_released = false if self.is_released.present?
		else
			self.patient_status = 'Closed'
		end
	end


	def provisional_diagnosis_confirmed
		(self.confirmation_date = Time.now.to_datetime) unless self.confirmation_date.present?
	end
	def current_patient_lab
		self.lab_name.present? ? self.lab_name : self.try(:lab_patient).try(:lab).try(:lab_name)
	end

	before_save :downcase_fields
	before_save :update_names_throu_ids
	
	## BEDS COUNT
	before_create :create_beds, if: Proc.new{|obj| is_hospital_user?(obj) or is_epc_user?(obj)}
	before_update :update_beds, if: Proc.new{|obj| is_hospital_user?(obj) or is_epc_user?(obj)}
	before_destroy :delete_beds, if: Proc.new{|obj| is_epc_user?(obj)}
	
	def update_names_throu_ids
		(self.hospital = Hospital.find(self.hospital_id).try(:hospital_name)) if hospital_id.present?
	end

	# def self.untagged_patient_data(tehsil_ids)
	# 	c1 = "(tehsil_id IN(?) and (residence_tagged is not true))"
	# 	c2 = "(workplace_tehsil_id IN(?) and (workplace_tagged is not true))"
	# 	c3 = "(permanent_tehsil_id IN(?) and (permanent_residence_tagged is not true))"
	# 	# c4 = "(provisional_diagnosis = 3)"
	# 	patients_data = Patient.get_patient_activities_prov_diag.where("( #{c1} or #{c2} or #{c3} )", tehsil_ids, tehsil_ids, tehsil_ids).ascending
	# 	return patients_data
	# end

	# def self.tagged_patients(tehsil_ids)
	# 	c1 = "(tehsil_id IN(?) and residence_tagged is true)"
	# 	c2 = "(workplace_tehsil_id IN(?) and workplace_tagged is true)"
	# 	c3 = "(permanent_tehsil_id IN(?) and permanent_residence_tagged is true)"
	# 	# c4 = "(provisional_diagnosis = 3)"

	# 	patients_data = Patient.get_patient_activities_prov_diag.where("( #{c1} or #{c2} or #{c3} )", tehsil_ids, tehsil_ids, tehsil_ids).ascending
	# 	return patients_data
	# end

	def self.untagged_generate_patient_list(patient, user_tehsils, place_type)
		patients_list = []

		( patients_list << self.generate_list_untagged_json(patient, 'residence', patient.residence_count, patient.address, patient.uc, patient.uc_id, patient.tehsil, patient.tehsil_id) ) if place_type == 'residence' and (patient.tehsil_id.present? and !patient.residence_tagged? and patient.address.present? and user_tehsils.include? patient.tehsil_id)

		( patients_list << self.generate_list_untagged_json(patient, 'workplace', patient.workplace_count, patient.workplace_address, patient.workplace_uc, patient.workplace_uc_id, patient.workplace_tehsil, patient.workplace_tehsil_id) ) if place_type == 'workplace' and (patient.workplace_tehsil_id.present? and !patient.workplace_tagged? and patient.workplace_address.present? and user_tehsils.include? patient.workplace_tehsil_id)

		( patients_list << self.generate_list_untagged_json(patient, 'permanent', patient.permanent_count, patient.permanent_address, patient.permanent_uc, patient.permanent_uc_id, patient.permanent_tehsil, patient.permanent_tehsil_id) ) if place_type == 'permanent' and (patient.permanent_tehsil_id.present? and !patient.permanent_residence_tagged? and patient.permanent_address.present? and user_tehsils.include? patient.permanent_tehsil_id)

	  return patients_list.flatten
  	end

	def self.tagged_generate_patient_list(patient, user_tehsils, place_type)
		patients_list = []
		
	  	( patients_list << self.generate_list_json(patient, 'residence', patient.residence_count, patient.address, patient.uc, patient.uc_id, patient.tehsil, patient.tehsil_id) ) if place_type == 'residence' and (patient.tehsil_id.present? and patient.residence_tagged? and user_tehsils.include? patient.tehsil_id)
	  	( patients_list << self.generate_list_json(patient, 'workplace', patient.workplace_count, patient.workplace_address, patient.workplace_uc, patient.workplace_uc_id, patient.workplace_tehsil, patient.workplace_tehsil_id) ) if place_type == 'workplace' and (patient.workplace_tehsil_id.present? and patient.workplace_tagged? and user_tehsils.include? patient.workplace_tehsil_id)
	  	( patients_list << self.generate_list_json(patient, 'permanent', patient.permanent_count, patient.permanent_address, patient.permanent_uc, patient.permanent_uc_id, patient.permanent_tehsil, patient.permanent_tehsil_id) ) if place_type == 'permanent' and  (patient.permanent_tehsil_id.present? and patient.permanent_residence_tagged? and user_tehsils.include? patient.permanent_tehsil_id)

	  	return patients_list.flatten
  	end

	def self.generate_list_json(patient_obj, patient_place, tag_count,  patient_address, patient_uc, patient_uc_id, patient_town, patient_town_id)
		
		{ 
			patient_id: patient_obj.id,
			patient_name: patient_obj.patient_name,
			patient_cnic_number:  patient_obj.cnic,
			patient_cnic_relation:  patient_obj.cnic_relation,
			patient_contact_number:  patient_obj.patient_contact,
			patient_phone_relation:  patient_obj.relation_contact,
			provisional_diagnosis: patient_obj.provisional_diagnosis,			
			patient_address:  patient_address,
			patient_uc:  patient_uc,
			patient_uc_id:  patient_uc_id,
			patient_town: patient_town,
			patient_town_id: patient_town_id,
			tag_count: tag_count,
			patient_place: patient_place,
			is_tagged: 1
		}
	end

	def self.generate_list_untagged_json(patient_obj, patient_place, tag_count,  patient_address, patient_uc, patient_uc_id, patient_town, patient_town_id)
		
		{ 
			patient_id: patient_obj.id,
			patient_name: patient_obj.patient_name,
			patient_cnic_number:  patient_obj.cnic,
			patient_cnic_relation:  patient_obj.cnic_relation,
			patient_contact_number:  patient_obj.patient_contact,
			patient_phone_relation:  patient_obj.relation_contact,
			provisional_diagnosis: patient_obj.provisional_diagnosis,			
			patient_address:  patient_address,
			patient_uc:  patient_uc,
			patient_uc_id:  patient_uc_id,
			patient_town: patient_town,
			patient_town_id: patient_town_id,
			tag_count: tag_count,
			patient_place: patient_place,
			is_tagged: 0
		}
	end

	def downcase_fields
		self.patient_name.try(:titleize)
		self.fh_name.try(:titleize)
		self.district.try(:titleize)
		self.tehsil.try(:titleize)
		self.uc.try(:titleize)
		self.permanent_district.try(:titleize)
		self.permanent_tehsil.try(:titleize)
		self.permanent_uc.try(:titleize)
		self.workplace_district.try(:titleize)
		self.workplace_tehsil.try(:titleize)
		self.workplace_uc.try(:titleize)
		self.passport.try(:titleize)
		self.province_id = (self.g_district.present? ?  self.g_district.province.id : nil)
	end
	def tag_increment(place)
		case place
		when 'residence'
		  self.residence_count+=1 if self.residence_count < 49
		  self.is_residence_household = true  if self.residence_count > 49
		when 'permanent'
		  self.permanent_count+=1 if self.permanent_count < 49
		  self.is_permanent_household = true  if self.permanent_count > 49
		when 'workplace'
		  self.workplace_count+=1 if self.workplace_count < 49
		  self.is_workplace_household = true  if self.workplace_count > 49
		end
	end
	def get_address(place)
		_address_ = ''
		case place
		when 'residence'
		 _address_ = self.address
		when 'permanent'
		  _address_ = self.permanent_address
		when 'workplace'
		  _address_ = self.workplace_address
		end
		return _address_
	end
	def load_lab_patient(lab_patient)
		self.lab_patient_id = lab_patient.id 
		self.patient_name = lab_patient.p_name 
		self.fh_name = lab_patient.fh_name
		self.age = lab_patient.age
		self.age_month = lab_patient.month
		self.gender = lab_patient.gender
		self.cnic_relation = lab_patient.cnic_type
		self.cnic = lab_patient.cnic
		self.patient_contact = lab_patient.contact_no
		self.relation_contact = lab_patient.other_contact_noputs
		self.permanent_district = lab_patient.perm_district
		self.permanent_district_id = lab_patient.perm_district_id
		self.permanent_tehsil = lab_patient.perm_tehsil
		self.permanent_tehsil_id = lab_patient.perm_tehsil_id
		self.permanent_uc = lab_patient.perm_uc
		self.permanent_uc_id = lab_patient.perm_uc_id 

		## workplace        
		self.workplace_address = lab_patient.workplc_address
		self.workplace_district = lab_patient.workplc_district
		self.workplace_district_id = lab_patient.workplc_district_id
		self.workplace_tehsil = lab_patient.workplc_tehsil
		self.workplace_tehsil_id = lab_patient.workplc_tehsil_id
		self.workplace_uc = lab_patient.workplc_uc
		self.workplace_uc_id		 = lab_patient.workplc_uc_id

		## labresults
			# FIRST READING
			self.lab_result.hct_first_reading = lab_patient.hct_first_reading 
			self.lab_result.hct_first_reading_date = lab_patient.hct_first_reading_date
			self.lab_result.wbc_first_reading = lab_patient.wbc_first_reading
			self.lab_result.wbc_first_reading_date = lab_patient.wbc_first_reading_date
			self.lab_result.platelet_first_reading = lab_patient.platelet_first_reading
			self.lab_result.platelet_first_reading_date = lab_patient.platelet_first_reading_date

			# SECOND READING
			self.lab_result.hct_second_reading = lab_patient.hct_second_reading
			self.lab_result.hct_second_reading_date = lab_patient.hct_second_reading_date
			self.lab_result.wbc_second_reading = lab_patient.wbc_second_reading
			self.lab_result.wbc_second_reading_date = lab_patient.wbc_second_reading_date
			self.lab_result.platelet_second_reading = lab_patient.platelet_second_reading
			self.lab_result.platelet_second_reading_date = lab_patient.platelet_second_reading_date

			# THIRD READING
			self.lab_result.hct_third_reading = lab_patient.hct_third_reading
			self.lab_result.hct_third_reading_date = lab_patient.hct_third_reading_date
			self.lab_result.wbc_third_reading = lab_patient.wbc_third_reading
			self.lab_result.wbc_third_reading_date = lab_patient.wbc_third_reading_date
			self.lab_result.platelet_third_reading = lab_patient.platelet_third_reading
			self.lab_result.platelet_third_reading_date = lab_patient.platelet_third_reading_date
			
		## LAB AND DIAGNOSTIC INFORMATION
		self.lab_result.ns1 = lab_patient.ns_1
		self.lab_result.pcr = lab_patient.pcr
		self.lab_result.igm = lab_patient.igm
		self.lab_result.igg = lab_patient.igg
		self.reporting_date = lab_patient.reporting_date
		self.confirmation_date = lab_patient.confirmation_date
		self.comments = lab_patient.comments
	end
	

	## Generate Bed
	def create_beds
		bed = Bed.find_by_hospital_id(hospital_id)
		bed = Bed.new(hospital_id: hospital_id) unless bed.present?
		bed = new_bed(bed)
		bed.save
	end
	def update_beds
		bed = Bed.find_by_hospital_id(hospital_id)
		bed = Bed.new(hospital_id: hospital_id) unless bed.present?
		if ( (patient_outcome == patient_outcome_was) and (provisional_diagnosis == provisional_diagnosis_was) and (patient_condition == patient_condition_was))
			puts "<<<<<<<<<<<<<<<<<<<<<<<<<< NO CHANGED >>>>>>>>>>>>>>>>>"
			if (bed.occupied_hdu_beds == 0 and bed.occupied_ward_beds == 0)
				puts "first entry ............................."
				bed = new_bed(bed)
				if bed.save
					puts "=== first entry saved"
				else 
					puts "==========firs entry = #{bed.errors.full_messages}"
				end
			end
		else
			# puts "====================================================="
			# puts "#{patient_outcome} .... #{patient_outcome_was}"
			# puts "====================================================="

			if provisional_diagnosis == 'Confirmed' 
				puts "========================================================="
				puts "========================================================="
				puts ""
				puts ""
				puts ""
				puts ""
				puts "#{patient_outcome}, #{provisional_diagnosis_was}, #{patient_condition}"
				puts ""
				puts ""
				puts ""
				puts ""
				puts "========================================================="
				puts "========================================================="
				## Non Dengue to Confirm Patient Admitted
				if provisional_diagnosis_was == 'Non-Dengue' and patient_outcome == 'Admitted'
					puts "======== 'Non Dengue to Confirm Patient Admitted"
					if patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1  ## go to stable condition
					elsif patient_condition == 'Stable'
						bed.occupied_ward_beds = bed.occupied_ward_beds + 1 ## go to critical condition
					end
				## 'Probable', 'Suspected' to Confirm Patient. >> if prob,sus is admitted and same move on confirm
				elsif ['Probable', 'Suspected'].include?(provisional_diagnosis_was) and patient_outcome_was == 'Admitted' and patient_outcome == 'Admitted'
					puts "======== ' 'Probable', 'Suspected' to Confirm Patient Admitted"
					if patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1  ## go to critical condition
						bed.occupied_ward_beds = bed.occupied_ward_beds - 1  ## go to stable condition
					end
				elsif ['Probable', 'Suspected'].include?(provisional_diagnosis_was) and patient_outcome_was != 'Admitted' and patient_outcome == 'Admitted'
					puts "======== ' 'Probable', 'Suspected' to Confirm Patient was not Admitted previous status"
					if patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1  ## go to stable condition
					elsif patient_condition == 'Stable'
						bed.occupied_ward_beds = bed.occupied_ward_beds + 1 ## go to critical condition
					end
				## if Admitted to (Discharg , Death, LAMA)
				elsif patient_outcome_was == 'Admitted' and ['Discharged', 'Death', 'LAMA', 'Outpatient'].include?(patient_outcome)
					puts "================ Admitted to (Discharg , Death, LAMA)"
					if patient_condition_was == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds - 1  ## go to stable condition
					elsif patient_condition_was == 'Stable'
						bed.occupied_ward_beds = bed.occupied_ward_beds - 1 ## go to critical condition
					end
				## Admitted to OutPatient
				elsif patient_outcome_was == 'Admitted' and patient_outcome == 'Outpatient'
					puts "================ Admitted to OutPatient"
					if patient_condition_was == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds - 1  ## go to stable condition
					elsif patient_condition_was == 'Stable'
						bed.occupied_ward_beds = bed.occupied_ward_beds - 1 ## go to critical condition
					end
				## Discharg , Death, LAMA to OutPatient
				elsif patient_outcome == 'Outpatient' and ['Discharged', 'Death', 'LAMA'].include?(patient_outcome_was)
					puts "================= not effect"
				## OutPatient to Discharg , Death, LAMA
				elsif patient_outcome_was == 'Outpatient' and ['Discharged', 'Death', 'LAMA'].include?(patient_outcome)
					puts "================= not effect"
					## Discharg , Death, LAMA to Admitted
				elsif patient_outcome == 'Admitted' and ['Discharged', 'Death', 'LAMA', 'Outpatient'].include?(patient_outcome_was)
					puts "================= convert condition changed /???????????????????????????"
					if patient_condition_was != patient_condition and patient_condition_was == 'Critical' and patient_condition == 'Stable'
						bed.occupied_ward_beds = bed.occupied_ward_beds + 1 ## go to critical condition
					elsif patient_condition_was != patient_condition and patient_condition_was == 'Stable' and patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1  ## go to stable condition
					elsif patient_condition_was == patient_condition and patient_condition == 'Stable'
						bed.occupied_ward_beds = bed.occupied_ward_beds + 1 ## go to critical condition
					elsif patient_condition_was == patient_condition and patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1  ## go to stable condition
					end
				elsif ( (patient_outcome_was == 'Admitted' and patient_outcome == 'Admitted') and (patient_condition_was.present? and patient_condition_was != patient_condition) )
					if patient_condition_was == 'Critical' and patient_condition == 'Stable'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds - 1
						bed.occupied_ward_beds = bed.occupied_ward_beds + 1
					elsif patient_condition_was == 'Stable' and patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1
						bed.occupied_ward_beds = bed.occupied_ward_beds - 1
					end
				elsif ( (patient_outcome_was == nil or patient_outcome_was == "") and patient_outcome_was != patient_outcome and patient_outcome == 'Admitted')
					puts "================ done"
					if patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1  ## go to stable condition
					elsif patient_condition == 'Stable'
						bed.occupied_ward_beds = bed.occupied_ward_beds + 1 ## go to critical condition
					end	
				end
			else
				bed = not_discharg(bed)
			end
				bed.occupied_hdu_beds = 0 if bed.occupied_hdu_beds < 0
				bed.occupied_ward_beds = 0 if bed.occupied_ward_beds < 0
			bed.save
		end
	end
	def not_discharg(bed)
		## if PV = PROB
		if ['Probable', 'Suspected'].include?(provisional_diagnosis)
			## From Non Dengue to Admitted
			if provisional_diagnosis_was == 'Non-Dengue' and patient_outcome == 'Admitted'
				puts "======== 'Non Dengue to Admitted"
				bed.occupied_ward_beds = bed.occupied_ward_beds + 1
			#Out Patient to Discharge, Death, LAMA 
			elsif patient_outcome_was == 'Outpatient' and ['Discharged', 'Death', 'LAMA'].include?(patient_outcome)
			
			## Admitted to 'Discharged', 'Death', 'LAMA', 'Outpatient'
			elsif patient_outcome_was == 'Admitted' and ['Discharged', 'Death', 'LAMA', 'Outpatient'].include?(patient_outcome)
				puts "======== Admitted to 'Discharged', 'Death', 'LAMA', 'Outpatient"
				bed.occupied_ward_beds = bed.occupied_ward_beds - 1
			## Discharged', 'Death', 'LAMA', 'Outpatient' to Admitted
			elsif ['Discharged', 'Death', 'LAMA', 'Outpatient'].include?(patient_outcome_was) and patient_outcome == 'Admitted'
				puts "======== 'Discharged', 'Death', 'LAMA', 'Outpatient to Admitted"
				bed.occupied_ward_beds = bed.occupied_ward_beds + 1
			elsif (patient_outcome != patient_outcome_was and patient_outcome == 'Admitted' and lab_user_id != nil)
				bed.occupied_ward_beds = bed.occupied_ward_beds + 1
			else 
				puts "==================== else condition 1"
				puts "===============#{patient_outcome}, #{provisional_diagnosis}"
			end
		elsif provisional_diagnosis == 'Non-Dengue'
			## if PV suspected or probable and patient outcome admitted it should be released
			if ['Suspected', 'Probable'].include?(provisional_diagnosis_was) and patient_outcome_was == 'Admitted'
				puts "============== if PV suspected or probable and patient outcome admitted it should be released"
				bed.occupied_ward_beds = bed.occupied_ward_beds - 1
			end
		end
			
		bed.occupied_hdu_beds = 0 if bed.occupied_hdu_beds < 0
		return bed
	end
	def new_bed(bed)
		if patient_outcome == 'Admitted' and provisional_diagnosis != 'Non-Dengue'
			if ['Suspected', 'Probable'].include?(provisional_diagnosis)
				bed.occupied_ward_beds = bed.occupied_ward_beds + 1
			elsif provisional_diagnosis == 'Confirmed'
				if patient_condition == 'Critical'
					bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1
				else
					bed.occupied_ward_beds = bed.occupied_ward_beds + 1
				end
			end
		end
		return bed
	end
	def delete_beds
		bed = Bed.find_by_hospital_id(hospital_id)
		if bed.present?
			if patient_outcome == 'Admitted'
				if ['Suspected', 'Probable'].include?(provisional_diagnosis)
					bed.occupied_ward_beds = bed.occupied_ward_beds - 1
				elsif provisional_diagnosis == 'Confirmed'
					if patient_condition == 'Critical'
						bed.occupied_hdu_beds = bed.occupied_hdu_beds - 1
					else
						bed.occupied_ward_beds = bed.occupied_ward_beds - 1
					end
				end
				bed.occupied_hdu_beds = 0 if bed.occupied_hdu_beds < 0
				bed.occupied_ward_beds = 0 if bed.occupied_ward_beds < 0
				# puts "=================================================== deleted #{}"
				bed.save
			end
		end
	end

	before_create :register_test_logs, if: Proc.new{|obj| updated_by.present?}
	
	def register_test_logs
		test_log = TestLog.new
		
		# FIRST READING
		test_log.hct_first_reading = lab_result.hct_first_reading
		test_log.hct_first_reading_date = lab_result.hct_first_reading_date
		test_log.wbc_first_reading = lab_result.wbc_first_reading
		test_log.wbc_first_reading_date = lab_result.wbc_first_reading_date
		test_log.platelet_first_reading = lab_result.platelet_first_reading
		test_log.platelet_first_reading_date = lab_result.platelet_first_reading_date

		# SECOND READING
		test_log.hct_second_reading = lab_result.hct_second_reading
		test_log.hct_second_reading_date = lab_result.hct_second_reading_date
		test_log.wbc_second_reading = lab_result.wbc_second_reading
		test_log.wbc_second_reading_date = lab_result.wbc_second_reading_date
		test_log.platelet_second_reading = lab_result.platelet_second_reading
		test_log.platelet_second_reading_date = lab_result.platelet_second_reading_date

		# THIRD READING
		test_log.hct_third_reading = lab_result.hct_third_reading
		test_log.hct_third_reading_date = lab_result.hct_third_reading_date
		test_log.wbc_third_reading = lab_result.wbc_third_reading
		test_log.wbc_third_reading_date = lab_result.wbc_third_reading_date
		test_log.platelet_third_reading = lab_result.platelet_third_reading
		test_log.platelet_third_reading_date = lab_result.platelet_third_reading_date

		## LAB AND DIAGNOSTIC INFORMATION
		test_log.ns1 = lab_result.ns1
		test_log.pcr = lab_result.pcr
		test_log.igm = lab_result.igm
		test_log.igg = lab_result.igg
		test_log.provisional_diagnosis = self.provisional_diagnosis
		test_log.change_by = updated_by.try(:username)
		test_log.reporting_date = self.reporting_date
		test_log.comments = self.comments
		test_log.patient_id = self.id
		test_log.patient_name = self.patient_name
		test_log.cnic = self.cnic
		test_log.passport = self.passport
		test_log.save
	end
	
	### confirmation by
	before_save :update_confirmation_date, unless: Proc.new{|obj| obj.confirmation_id.present?}
	def update_confirmation_date
		if self.provisional_diagnosis == 'Confirmed' and updated_id.present?
			self.confirmation_id = updated_id
			self.confirmation_role = updated_by.lab_user? ? 'Confirmed by Lab' : 'Confirmed by Hospital'
		end
	end

	before_update :change_test_logs, if: Proc.new{|obj| updated_by.present?}
	
	def change_test_logs
		test_log = TestLog.new
		is_changed = false
		# FIRST READING
		begin
			if lab_result.present?
				if lab_result.hct_first_reading_was != lab_result.hct_first_reading
					(test_log.hct_first_reading = lab_result.hct_first_reading_was)
					is_changed = true
				end
				if lab_result.hct_first_reading_date_was != lab_result.hct_first_reading_date
					(test_log.hct_first_reading_date = lab_result.hct_first_reading_date_was)
					is_changed = true
				end
				if lab_result.wbc_first_reading_was != lab_result.wbc_first_reading
					(test_log.wbc_first_reading = lab_result.wbc_first_reading_was)
					is_changed = true
				end
				if lab_result.wbc_first_reading_date_was != lab_result.wbc_first_reading_date
					(test_log.wbc_first_reading_date = lab_result.wbc_first_reading_date_was)
					is_changed = true
				end
				if lab_result.platelet_first_reading_was != lab_result.platelet_first_reading
					(test_log.platelet_first_reading = lab_result.platelet_first_reading_was)
					is_changed = true
				end
				if lab_result.platelet_first_reading_date_was != lab_result.platelet_first_reading_date
					(test_log.platelet_first_reading_date = lab_result.platelet_first_reading_date_was)
					is_changed = true
				end

				# SECOND READING
				if lab_result.hct_second_reading_was != lab_result.hct_second_reading
					(test_log.hct_second_reading = lab_result.hct_second_reading_was)
					is_changed = true
				end
				if lab_result.hct_second_reading_date_was != lab_result.hct_second_reading_date
					(test_log.hct_second_reading_date = lab_result.hct_second_reading_date_was)
					is_changed = true
				end
				if lab_result.wbc_second_reading_was != lab_result.wbc_second_reading
					(test_log.wbc_second_reading = lab_result.wbc_second_reading_was)
					is_changed = true
				end
				if lab_result.wbc_second_reading_date_was != lab_result.wbc_second_reading_date
					(test_log.wbc_second_reading_date = lab_result.wbc_second_reading_date_was)
					is_changed = true
				end
				if lab_result.platelet_second_reading_was != lab_result.platelet_second_reading
					(test_log.platelet_second_reading = lab_result.platelet_second_reading_was)
					is_changed = true
				end
				if lab_result.platelet_second_reading_date_was != lab_result.platelet_second_reading_date
					(test_log.platelet_second_reading_date = lab_result.platelet_second_reading_date_was)
					is_changed = true
				end

				# THIRD READING
				if lab_result.hct_third_reading_was != lab_result.hct_third_reading
					(test_log.hct_third_reading = lab_result.hct_third_reading_was)
					is_changed = true
				end
				if lab_result.hct_third_reading_date_was != lab_result.hct_third_reading_date
					(test_log.hct_third_reading_date = lab_result.hct_third_reading_date_was)
					is_changed = true
				end
				if lab_result.wbc_third_reading_was != lab_result.wbc_third_reading
					(test_log.wbc_third_reading = lab_result.wbc_third_reading_was)
					is_changed = true
				end
				if lab_result.wbc_third_reading_date_was != lab_result.wbc_third_reading_date
					(test_log.wbc_third_reading_date = lab_result.wbc_third_reading_date_was)
					is_changed = true
				end
				if lab_result.platelet_third_reading_was != lab_result.platelet_third_reading
					(test_log.platelet_third_reading = lab_result.platelet_third_reading_was)
					is_changed = true
				end
				if lab_result.platelet_third_reading_date_was != lab_result.platelet_third_reading_date
					(test_log.platelet_third_reading_date = lab_result.platelet_third_reading_date_was)
					is_changed = true
				end

				## LAB AND DIAGNOSTIC INFORMATION
				if lab_result.ns1_was != lab_result.ns1
					(test_log.ns1 = lab_result.ns1_was)
					is_changed = true
				end
				if lab_result.pcr_was != lab_result.pcr
					(test_log.pcr = lab_result.pcr_was)
					is_changed = true
				end
				if lab_result.igm != lab_result.igm
					(test_log.igm = lab_result.igm_was)
					is_changed = true
				end
				if lab_result.igg_was != lab_result.igg
					(test_log.igg = lab_result.igg_was)
					is_changed = true
				end
				if self.provisional_diagnosis_was != self.provisional_diagnosis
					(test_log.provisional_diagnosis = self.provisional_diagnosis_was)
					is_changed = true
				end
				if self.reporting_date_was != self.reporting_date
					(test_log.reporting_date = self.reporting_date_was)
					is_changed = true
				end
				if self.comments_was != self.comments
					(test_log.comments = self.comments_was)
					is_changed = true
				end
				if is_changed
					(test_log.change_by = updated_by.try(:username))
					test_log.patient_id = self.id
					test_log.patient_name = self.patient_name
					test_log.cnic = self.cnic
					test_log.passport = self.passport
					test_log.save
				end
			end
		end		
	end
	
	def is_hospital_user?(obj)
		(obj.updated_by.present? and obj.updated_by.hospital_user?)
	end
	def is_lab_user?(obj)
		(obj.updated_by.present? and obj.updated_by.lab_user?)
	end
	def is_epc_user?(obj)
		(obj.updated_by.present? and obj.updated_by.epc_user?)
	end
	# enum provisional_diagnosis: { "Non-Dengue": 0, "Probable": 1, "Suspected": 2, "Confirmed": 3}

	def self.is_unique_identification_from_lab?(p_name, p_contact)
		patient = Patient.is_uniq_p_name(p_name).is_uniq_p_contact(p_contact)
	end

	def patient_name_and_contact_should_unique
		patient = Patient.is_unique_identification_from_lab?(self.patient_name, self.patient_contact)
		if patient.present?
			if new_record? and patient.count > 0
				puts "present or not"
				errors.add(:patient_name, "Patient Name and Phone Number already Exist")
			else
				if patient.count > 1
					errors.add(:patient_name, "Patient Name and Phone Number already Exist")
				end
			end
		end
		true
	end

	def valid_api_from_lab?
		['Admitted', 'Outpatient'].exclude?(self.patient_outcome)
	end

	## CSV/XSLX/XLS

	def self.to_csv(current_user, is_empty = true)
		if is_empty == true
			if current_user.lab_user?
				patient_headers = ["Sr No.", "Patient ID", "Patient name", "Father/Husband name", "Age", "Gender", "CNIC/Passport", "Guardian's Relation", "Patient contact", "#{current_user.admin? ? 'Updated By' : 'Relation contact'}", "Entry Date", "Hospital/Lab", "Address", "District", "Tehsil", "UC", "Residence House Tagged", "Permanent address", "Permanent district", "Permanent tehsil", "Permanent UC", "Permanent House Tagged", "Workplace address", "Workplace district", "Workplace tehsil", "Workplace UC", "Workplace Tagged", "Date of onset", "Fever last for", "Fever", "Previous dengue fever", "Associated Symptoms", "Provisional diagnosis", "Confirmation Date", "Other diagnosed fever", "Patient status", "Patient condition", "Patient outcome", "Reporting Date", "Entered By", "Created By", "Lab Name"]
				CSV.generate(headers: true) do |csv|
					csv << patient_headers
					all.each_with_index do |patient, i|
						patient_row = lab_user(i, patient, current_user)
						csv << patient_row
					end
				end
			else
				patient_headers = ["Sr No.", "Patient ID", "Patient name", "Father/Husband name", "Age", "Gender", "CNIC/Passport", "Guardian's Relation", "Patient contact", "#{current_user.admin? ? 'Updated By' : 'Relation contact'}", "Entry Date", "Hospital/Lab", "Address", "District", "Tehsil", "UC", "Residence House Tagged", "Permanent address", "Permanent district", "Permanent tehsil", "Permanent UC", "Permanent House Tagged", "Workplace address", "Workplace district", "Workplace tehsil", "Workplace UC", "Workplace Tagged", "Date of onset", "Fever last for", "Fever", "Previous dengue fever", "Associated Symptoms", "Provisional diagnosis", "Confirmation Date", "Other diagnosed fever", "Patient status", "Patient condition", "Patient outcome","Admission Date", "Death Date", "Discharged Date", "Reporting Date", "Entered By", "Created By", "Lab Name", "NS1","PCR","IGG","IGM","Advised Test","Report ordering date","Report receiving date", "Lab Turnaround Time", "First Report Order Date", "First Report Receiving Date", "Second Report Order Date", "Second Report Receiving Date", "Third Report Order Date", "Third Report Receiving Date", "First Turnaround Time", "Second Turnaround Time", "Third Turnaround Time"]
				CSV.generate(headers: true) do |csv|
					csv << patient_headers
					all.each_with_index do |patient, i|
						patient_row = patient_user(i, patient, current_user)
						csv << patient_row
					end
				end
			end
		else
			if current_user.lab_user?
				patient_headers = ["Sr No.", "Patient ID", "Patient name", "Father/Husband name", "Age", "Gender", "CNIC/Passport", "Guardian's Relation", "Patient contact", "#{current_user.admin? ? 'Updated By' : 'Relation contact'}", "Entry Date", "Hospital/Lab", "Address", "District", "Tehsil", "UC", "Residence House Tagged", "Permanent address", "Permanent district", "Permanent tehsil", "Permanent UC", "Permanent House Tagged", "Workplace address", "Workplace district", "Workplace tehsil", "Workplace UC", "Workplace Tagged", "Date of onset", "Fever last for", "Fever", "Previous dengue fever", "Associated Symptoms", "Provisional diagnosis", "Confirmation Date", "Other diagnosed fever", "Patient status", "Patient condition", "Patient outcome", "Reporting Date", "Entered By", "Created By", "Lab Name"]
				CSV.generate(headers: true) do |csv|
					csv << patient_headers
				end
			else
				patient_headers = ["Sr No.", "Patient ID", "Patient name", "Father/Husband name", "Age", "Gender", "CNIC/Passport", "Guardian's Relation", "Patient contact", "#{current_user.admin? ? 'Updated By' : 'Relation contact'}", "Entry Date", "Hospital/Lab", "Address", "District", "Tehsil", "UC", "Residence House Tagged", "Permanent address", "Permanent district", "Permanent tehsil", "Permanent UC", "Permanent House Tagged", "Workplace address", "Workplace district", "Workplace tehsil", "Workplace UC", "Workplace Tagged", "Date of onset", "Fever last for", "Fever", "Previous dengue fever", "Associated Symptoms", "Provisional diagnosis", "Confirmation Date", "Other diagnosed fever", "Patient status", "Patient condition", "Patient outcome","Admission Date", "Death Date", "Discharged Date", "Reporting Date", "Entered By", "Created By", "Lab Name", "NS1","PCR","IGG","IGM","Advised Test","Report ordering date","Report receiving date", "Lab Turnaround Time", "First Report Order Date", "First Report Receiving Date", "Second Report Order Date", "Second Report Receiving Date", "Third Report Order Date", "Third Report Receiving Date", "First Turnaround Time", "Second Turnaround Time", "Third Turnaround Time"]
				CSV.generate(headers: true) do |csv|
					csv << patient_headers
				end
			end
		end
	end
	
	def self.lab_user(i, patient, current_user)
		[i+1,
		patient.id,
		patient.patient_name,
		patient.fh_name,
		patient.age,
		patient.gender,
		(patient.p_search_type == 'CNIC' ? patient.cnic : patient.passport),
		patient.cnic_relation,
		patient.patient_contact,
		(current_user.admin? ? ( patient.updated_by.try(:username) || patient.user.try(:username)) : patient.relation_contact),
		ApplicationController.helpers.datetime(patient.created_at),
		patient.hospital,
		patient.address,
		patient.district,
		patient.tehsil,
		patient.uc,
		patient.residence_tagged,
		patient.permanent_address,
		patient.permanent_district,
		patient.permanent_tehsil,
		patient.permanent_uc,
		patient.permanent_residence_tagged,
		patient.workplace_address,
		patient.workplace_district,
		patient.workplace_tehsil,
		patient.workplace_uc,
		patient.workplace_tagged,
		patient.date_of_onset,
		patient.fever_last_till,
		patient.fever,
		patient.previous_dengue_fever,
		patient.associated_symptom,
		patient.provisional_diagnosis,
		ApplicationController.helpers.datetime(patient.confirmation_date),
		patient.other_diagnosed_fever,
		patient.patient_status,
		patient.patient_condition,
		patient.patient_outcome,
		(patient.reporting_date? ? ApplicationController.helpers.datetime(patient.reporting_date) : nil),
		patient.entered_by,
		(patient.from_lab.try(:username) || patient.user.try(:username)),
		(patient.lab_name.present? ? patient.lab_name : patient.try(:lab_patient).try(:lab).try(:lab_name))]
	end
	def self.patient_user(i, patient, current_user)
		lab_result = patient.lab_result
		if (lab_result.present? and ["Confirmed", "Probable"].include?(patient.provisional_diagnosis))
			ns1 = lab_result.ns1
			pcr = lab_result.pcr
			igg = lab_result.igg
			igm = lab_result.igm

		else
			ns1 = "N/A"
			pcr = "N/A"
			igg = "N/A"
			igm = "N/A"
		end

		if lab_result.present?
			cbc_report_order_date_first 	= lab_result.cbc_report_order_date_first.strftime("on %m/%d/%Y at %I:%M%p") rescue "N/A"
			cbc_report_order_date_second 	= lab_result.cbc_report_order_date_second.strftime("on %m/%d/%Y at %I:%M%p") rescue "N/A"
			cbc_report_order_date_third 	= lab_result.cbc_report_order_date_third.strftime("on %m/%d/%Y at %I:%M%p") rescue "N/A"
			cbc_report_receiving_date_first = lab_result.cbc_report_receiving_date_first.strftime("on %m/%d/%Y at %I:%M%p") rescue "N/A"
			cbc_report_receiving_date_second = lab_result.cbc_report_receiving_date_second.strftime("on %m/%d/%Y at %I:%M%p") rescue "N/A"
			cbc_report_receiving_date_third = lab_result.cbc_report_receiving_date_third.strftime("on %m/%d/%Y at %I:%M%p") rescue "N/A"
			
			lab_turnaround_time = lab_result.time_diff(lab_result.lab_turnaround_time)
			cbc_turnaround_first = lab_result.time_diff(lab_result.cbc_turnaround_first)
			cbc_turnaround_second = lab_result.time_diff(lab_result.cbc_turnaround_second)
			cbc_turnaround_third = lab_result.time_diff(lab_result.cbc_turnaround_third)
		else
			cbc_report_order_date_first = "N/A"
			cbc_report_order_date_second = "N/A"
			cbc_report_order_date_third = "N/A"
			cbc_report_receiving_date_first = "N/A"
			cbc_report_receiving_date_second = "N/A"
			cbc_report_receiving_date_third = "N/A"
			
			lab_turnaround_time = "N/A"
			cbc_turnaround_first = "N/A"
			cbc_turnaround_second = "N/A"
			cbc_turnaround_third = "N/A"
		end

		[i+1,
		patient.id,
		patient.patient_name,
		patient.fh_name,
		patient.age,
		patient.gender,
		(patient.p_search_type == 'CNIC' ? patient.cnic : patient.passport),
		patient.cnic_relation,
		patient.patient_contact,
		(current_user.admin? ? ( patient.updated_by.try(:username) || patient.user.try(:username)) : patient.relation_contact),
		ApplicationController.helpers.datetime(patient.created_at),
		patient.hospital,
		patient.address,
		patient.district,
		patient.tehsil,
		patient.uc,
		patient.residence_tagged,
		patient.permanent_address,
		patient.permanent_district,
		patient.permanent_tehsil,
		patient.permanent_uc,
		patient.permanent_residence_tagged,
		patient.workplace_address,
		patient.workplace_district,
		patient.workplace_tehsil,
		patient.workplace_uc,
		patient.workplace_tagged,
		patient.date_of_onset,
		patient.fever_last_till,
		patient.fever,
		patient.previous_dengue_fever,
		patient.associated_symptom,
		patient.provisional_diagnosis,
		ApplicationController.helpers.datetime(patient.confirmation_date),
		patient.other_diagnosed_fever,
		patient.patient_status,
		patient.patient_condition,
		patient.patient_outcome,
		patient.admission_date.try(:strftime, "%d/%m/%Y"),
		patient.death_date.try(:strftime, "%d/%m/%Y"),
		patient.discharge_date.try(:strftime, "%d/%m/%Y"),
		(patient.reporting_date? ? patient.reporting_date.strftime("%d/%m/%Y") : nil),
		patient.entered_by,
		(patient.from_lab.try(:username) || patient.user.try(:username)),
		(patient.lab_name.present? ? patient.lab_name : patient.try(:lab_patient).try(:lab).try(:lab_name)),
		ns1,
		pcr,
		igg,
		igm,
		lab_result.present? ? lab_result.advised_test.try(:join, ",") : 'N/A',
		lab_result.present? ? (lab_result.report_ordering_date.try(:strftime, "on %m/%d/%Y at %I:%M%p")) : 'N/A',
		lab_result.present? ? (lab_result.report_receiving_date.try(:strftime, "on %m/%d/%Y at %I:%M%p")) : 'N/A',
		lab_turnaround_time,
		cbc_report_order_date_first,
		cbc_report_receiving_date_first,
		cbc_report_order_date_second,
		cbc_report_receiving_date_second,
		cbc_report_order_date_third,
		cbc_report_receiving_date_third,
		cbc_turnaround_first,
		cbc_turnaround_second,
		cbc_turnaround_third
	]
	end
	
	def self.diagnosis_change_log_csv(current_user, q)
		patient_lab_tests_headers = ["Sr No.", "Province", "District", "Hospital", "Facility Type", "Patient ID", "Patient Name", "Suspected", "Probable", "Confirmed", "Non-Dengue"]
		CSV.generate(headers: true) do |csv|
			csv << patient_lab_tests_headers
			@patients = Patient.find_by_sql(q)
			@patients.each_with_index do |patient, i|
				patient_row = self.diagnosis_change_log_data(i, patient)
				csv << patient_row
			end
		end
	end


	def self.diagnosis_change_log_data(i, patient)
		return [i+1, patient.province, patient.district, patient.hospital, patient.facility_type, patient.patient_id, patient.patient_name, patient.suspected ||= '-', patient.probable ||= '-', patient.confirmed ||= '-', patient.non_dengue ||= '-']
	end
end
