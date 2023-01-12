class Reports::PatientController < Reports::ApplicationController
	include ReportsHelper
	def epidemiological
		@hospitals = []
		authorize! :read, Patient

		if is_epidemiological_filters_active?
			@patient_provisional_diagnosis = Patient.accessible_by(current_ability, :read).group(:provisional_diagnosis, :hospital).filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_hospital_id(params[:hospital]).filter_by_datefrom(params[:from]).filter_by_dateto(params[:to]).count
			@patient_patient_outcome = Patient.accessible_by(current_ability, :read).group(:patient_outcome, :hospital).filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_hospital_id(params[:hospital]).filter_by_datefrom(params[:from]).filter_by_dateto(params[:to]).count

			@hospitals = Hospital.joins(:district).includes(district: :province).order("hospitals.hospital_name asc, districts.district_name asc").filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_hospital(params[:hospital])
		end

		respond_to do |format|
			format.html
			format.xls
		end
	end
	
	def monthly_patients
		authorize! :read, Patient

		@patient_dates = []
		if are_monthly_patients_filters_active?
			@patients = Patient.accessible_by(current_ability, :read).filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_tehsil_id(params[:tehsil]).filter_by_uc_id(params[:uc]).filter_by_month(params[:month]).filter_by_year(params[:year]).group(:provisional_diagnosis,"created_at::date").order("DATE(created_at)").count
			
			## collect uniq dates from patients queries
			@patients.keys.each{|p| @patient_dates << p.last}
			@patient_dates = @patient_dates.uniq


			@patients.each do |p|
				puts "#{p}"
			end
		end
	end

	def zero_patient
		#Remove filter by district id

		authorize! :zero_patient, Patient
		@patient_provisional_diagnosis = Patient.accessible_by(current_ability, :read).group(:provisional_diagnosis, :hospital).filter_by_province_id(params[:province]).filter_by_hospital_id(params[:hospital]).filter_by_from(params[:from]).filter_by_to(params[:to]).count
		@hospitals = Hospital.accessible_by(current_ability, :read).joins(:district).includes(district: :province).order("hospitals.hospital_name asc, districts.district_name asc").filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_hospital(params[:hospital]).facility_type(params[:facility_type]).category(params[:category])
		@zero_patient = ZeroPatient.accessible_by(current_ability, :read).where(t_type: :patient).group(:district_id, :hospital).filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_hospital_id(params[:hospital]).filter_by_from(params[:from]).filter_by_to(params[:to]).count
	end

	def zero_lab_patient
		authorize! :zero_lab_patient, LabPatient
		
		
		# @patient_provisional_diagnosis = LabPatient.accessible_by(current_ability, :read).group(:provisional_diagnosis, :district_id, :lab_name).filter_by_lab_id(params[:lab]).filter_by_d_from(params[:from]).filter_by_d_to(params[:to]).count
		# @labs = Lab.accessible_by(current_ability, :read).joins(:district).order("labs.lab_name asc, districts.district_name asc").filter_by_district_id(params[:district]).filter_by_lab_id(params[:lab])
		# @zero_patient = ZeroPatient.accessible_by(current_ability, :read).where(t_type: :lab_patient).group(:district_id, :lab).filter_by_district_id(params[:district]).filter_by_lab_id(params[:lab]).filter_by_from(params[:from]).filter_by_to(params[:to]).count
		
		@patient_provisional_diagnosis = Patient.accessible_by(current_ability, :read).group(:provisional_diagnosis, :district_id, :hospital).filter_by_province_id(params[:province]).filter_by_hospital_id(params[:lab]).filter_by_from(params[:from]).filter_by_to(params[:to]).count

		@labs = Hospital.accessible_by(current_ability, :read).joins(:district).includes(district: :province).order("hospitals.hospital_name asc, districts.district_name asc").filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_hospital(params[:lab]).facility_type(params[:facility_type]).category(params[:category])

		@zero_patient = ZeroPatient.accessible_by(current_ability, :read).where(t_type: :lab_patient).group(:district_id, :hospital).filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_hospital_id(params[:lab]).filter_by_from(params[:from]).filter_by_to(params[:to]).count


	end
	

	def provisional_diagnosis_uc_wise
		authorize! :read, Patient

		@provisional_diagnosis_uc_wise = Patient.accessible_by(current_ability, :read).group(:provisional_diagnosis, :district_id, :tehsil_id, :uc_id).filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_uc_id(params[:uc]).filter_by_tehsil_id(params[:town]).filter_by_from(params[:from]).filter_by_to(params[:to]).count
		@ucs = Uc.accessible_by(current_ability, :read).includes(:district, :tehsil).filter_by_province_id(params[:province]).filter_by_district_id(params[:district]).filter_by_tehsil_id(params[:town]).filter_by_uc(params[:uc]).order("uc_name").all
	end
end