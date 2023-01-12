class DengueSituation < ApplicationRecord

  belongs_to :user, :primary_key => 'id', :foreign_key => "user_id", :class_name => "MobileUser" , optional: true
  belongs_to :district, optional: true

	## scopes
	scope :ascending, ->{order("dengue_situations.created_at DESC")}
	scope :filter_by_user_id, ->(data){where("dengue_situations.user_id =?", data)}
  scope :filter_by_district_id, ->(data){data.present? ? where("dengue_situations.district_id =?", data) : where("true")}

	scope :filter_by_datefrom, ->(data){data.present? ? (where("dengue_situations.entery_date >= ?", data) ) : where("true")}
	scope :filter_by_dateto, ->(data){data.present? ? (where("dengue_situations.entery_date <= ?", data) ) : where("true")}

  ## validates
  validates :user_id, presence: {message: 'User should be required'}
  validates :entery_date, presence: {message: 'Entery Date should be required'}
  validates :district_id, presence:{message: "Please Select District"}


  def self.to_csv(current_user, is_empty = true)
		dengue_situation_headers = ["Sr No.#", "Confirmed patient", "Patient reported by lab", "Patient reported by hospital", "Death", "Admissions", "Case reponse", "Indoor positive larvae", "Outdoor positive larvae", "Hotspots Coverage %", "Dormant Users", "Firs", "Notices served", "Premises sealed", "Arrests", "Fines imposed", "Dvrs total", "Dvrs resolved", "Dvrs pending", "District", "Entered By", "Entery Date", "Created At"]
    CSV.generate(headers: true) do |csv|
      csv << dengue_situation_headers
      all.each_with_index do |dengue_situation, i|
        dengue_situation_row = dengue_situation_data(i, dengue_situation, current_user)
        csv << dengue_situation_row
      end
    end
	end

  def self.dengue_situation_data(i, dengue_situation, current_user)
		[i+1,
      dengue_situation.confirmed_patient, 
      dengue_situation.patient_reported_by_lab, 
      dengue_situation.patient_reported_by_hospital, 
      dengue_situation.death, 
      dengue_situation.admissions, 
      dengue_situation.case_reponse, 
      dengue_situation.indoor_positive_larvae, 
      dengue_situation.outdoor_positive_larvae, 
      dengue_situation.hotspots_coverage, 
      dengue_situation.dormant_users, 
      dengue_situation.firs, 
      dengue_situation.notices_served, 
      dengue_situation.premises_sealed, 
      dengue_situation.arrests, 
      dengue_situation.fines_imposed, 
      dengue_situation.dvrs_total, 
      dengue_situation.dvrs_resolved, 
      dengue_situation.dvrs_pending, 
      dengue_situation.district_name, 
      dengue_situation.user.try(:username), 
      dengue_situation.entery_date.try(:to_date).try(:strftime, "%m/%d/%Y"), 
      dengue_situation.created_at.to_datetime.strftime("%m/%d/%Y")
    ]
	end
end
