module PatientsHelper
	def dynamic_patient_listing
		return current_user.lab_user? ? 'labs' : 'hospitals'
	end
	def is_disabled_cbc_and_hct?(lab_patient)
		if @patient.provisional_diagnosis == "Confirmed"
			if  (lab_patient.object.hct_second_reading.present? and 
				lab_patient.object.wbc_second_reading.present? and
				lab_patient.object.platelet_second_reading.present?)
				
				return "disabledbutton"
			end
		end
	end
	def is_disabled_cbc_and_hct_third_row?(lab_patient)
		if @patient.provisional_diagnosis == "Confirmed"
			if  (lab_patient.object.hct_third_reading.present? and 
				lab_patient.object.wbc_third_reading.present? and
				lab_patient.object.platelet_third_reading.present?)
				
				return "disabledbutton"
			end
		end
	end

	def user_wise_districts
		districts = District.accessible_by(current_ability, :read).order("district_name").collect { | dist | [dist.district_name, dist.id] }
		return districts
	end

	def district_wise_tehsils(dist_id)
		if dist_id.present?
			tehsils = Tehsil.accessible_by(current_ability, :read).where("district_id = #{dist_id}").order("tehsil_name").collect { | tehs | [tehs.tehsil_name, tehs.id] }
			return tehsils
		else
			return []
		end
	end

	def tehsil_wise_ucs(dist_id,teh_id)
		if dist_id.present? and teh_id.present?
			ucs = Uc.where("district_id = #{dist_id} and tehsil_id = #{teh_id}").order("uc_name").collect { | uc | [uc.uc_name, uc.id] }
			return ucs
		else
			return []
		end
	end

	def provisional_diagnosis_list
		return ["Confirmed", "Non-Dengue", "Probable", "Suspected"]
	end

	def probable_provisional_diagnosis_list
		return ["Confirmed", "Non-Dengue", "Probable"]
	end
	
	def provisional_diagnosis_list_for_lab_patients
		return ["Confirmed", "Probable"]
	end

	def other_diagnosed_fevers_list
		return ["CCHF","Chikungunya Viral Infection" ,"Coxsackievirus", "Hantavirus", "HIV Seroconversion", "Infectious Mononucleosis", "Influenza", "Kawasaki Disease","Malaria", "Measles", "Meningococcal Septicaemia", "Other Haemorrhagic Infections","Parvovirus B19", "Rickettsial Infections", "Rubella","Scrub Typhus","Typhoid Fever", "Typhus", "Weil's Disease (Leptospirosis)", "Yellow Fever"]
 	end

	def patient_status_list
		return ["Closed", "In Process", "Lab"]
	end
	def hotspot_status_list
		return [["Active",true],["Inactive",false]]
	end

	def patient_outcomes_list
			return ["Death","Discharged","LAMA","Outpatient","Admitted"]
	end

	def patient_conditions_list
		return ["Critical", "Stable"]
	end
	
	def lab_diagnostic_list
		return ["Positive", "Negative", "Not Prescribed", "Awaited"]
	end

	def diagnosis_list
		return ["Dengue Fever", "Dengue Hemorrhagic Fever", "DSS(Dengue Shock Syndrome)", "Other"]
	end

	def dengue_virus_type_list
		return ["Denv1", "Denv2", "Denv3", "Denv4", "Not Advised", "Not Available"]
	end

	def is_disabled_confirmed_pd?(form)
		if @patient.provisional_diagnosis == "Confirmed"
			if form.object.new_record? and form.object.lab_patient_id == nil
				return false
			elsif form.object.new_record? and form.object.lab_patient_id != nil
				return true
			elsif form.object.persisted?
				# puts "=========#{@patient.lab_user_id}, #{@patient.patient_outcome}"
				if @patient.user_id.present?
					return true
				else
					if @patient.lab_user_id.present?
						return false
					else
						return true
					end
				end
			end
		end
	end
	def is_disabled_patient_condition_confirmed_pd?(form)
		if @patient.provisional_diagnosis == "Confirmed"
			if form.object.new_record? and form.object.lab_patient_id == nil
				return false
			elsif form.object.new_record? and form.object.lab_patient_id != nil
				return true
			elsif form.object.persisted?
				return false
			end
		end
	end
	def is_disabled_confirmed_dpc_user?(form)
		if @patient.provisional_diagnosis == "Confirmed"
			if form.object.new_record? and form.object.lab_patient_id == nil
				return false
			elsif form.object.new_record? and form.object.lab_patient_id != nil
				if current_user.dpc_user?
					return false
				else
					return true
				end
			elsif form.object.persisted?
				if @patient.lab_user_id.present?
					return false
				else
					return true
				end
			end
		end
	end
	def is_disabled_not_confirmed?(form)
		if @patient.provisional_diagnosis == "Confirmed"
			return false
		else
			return true
		end
	end
	def is_lab_pv_disabled?
		(@patient.user_id.present? and @patient.patient_outcome.present? and @patient.provisional_diagnosis == 'Confirmed') ? true : false
	end
	def is_lab_confirmed?
		(@patient.provisional_diagnosis == 'Confirmed') ? true : false
	end
	def patient_lab_tests_summary(where_clause)
			"SELECT 
			PatientID as patient_id,
			max(hospital_province_name) as province,
			max(hospital_district_name) as district,
			max(hospital_province_id) as province_id,
			max(hospital_district_id) as district_id,
			max(patient_hospital) as hospital,
			max(patient_hospital_id) as hospital_id,
			max(facility_type) as facility_type,
			max(patient_name) as patient_name,
			max(TO_CHAR(entry_date, 'YYYY-MM-DD HH12:MI AM')) as entry_date,
			max(CASE WHEN (pd = '2' or pd = '[0, 2]' or pd = '[1, 2]' or pd = '[3, 2]') THEN TO_CHAR(updated_date, 'YYYY-MM-DD HH12:MI AM') END) AS suspected,
			max(CASE WHEN (pd = '1' or pd = '[0, 1]' or pd = '[2, 1]' or pd = '[3, 1]') THEN TO_CHAR(updated_date, 'YYYY-MM-DD HH12:MI AM') END) AS probable,
			max(CASE WHEN (pd = '3' or pd = '[0, 3]' or pd = '[1, 3]' or pd = '[2, 3]') THEN TO_CHAR(updated_date, 'YYYY-MM-DD HH12:MI AM') END) AS confirmed,
			max(CASE WHEN (pd = '0' or pd = '[1, 0]' or pd = '[2, 0]' or pd = '[3, 0]') THEN TO_CHAR(updated_date, 'YYYY-MM-DD HH12:MI AM') END) AS non_dengue 
		From 
			(SELECT
				h_prov.id AS hospital_province_id,
				h_prov.province_name AS hospital_province_name,
				hos.district_id as hospital_district_id,
				h_dis.district_name as hospital_district_name,
				p.hospital as patient_hospital,
				p.hospital_id as patient_hospital_id,
				hos.facility_type as facility_type,
				p.patient_name,
				auditable_id as PatientID, 
				audits.created_at as updated_date,
				 (CASE WHEN audits.action = 'create' then audits.created_at END) AS entry_date,
				(audited_changes->'provisional_diagnosis') as pd
			FROM audits
				INNER JOIN patients p ON audits.auditable_id = p.ID AND audits.user_id is not null
				INNER JOIN hospitals hos ON hos.id = p.hospital_id
				INNER JOIN districts h_dis ON hos.district_id = h_dis.ID
				INNER JOIN provinces h_prov ON h_prov.id = h_dis.province_id
				WHERE 
					audits.auditable_type = 'Patient' AND 
					p.created_at >= DATE '2022-01-01' AND #{where_clause} AND
					P.deleted_at IS NULL AND
					((audited_changes->'provisional_diagnosis') is not null)) as iq
		group by PatientID
		ORDER BY PatientID DESC"
	end
end
