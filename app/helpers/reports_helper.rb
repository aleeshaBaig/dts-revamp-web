module ReportsHelper

	## Epidemiological
	def get_data_epidemiological(hospital)
		data = {}
		data[:district] = hospital.district.district_name if hospital.district.present?
		data[:division] = hospital.district.division_name if hospital.district.present?
		data[:province] = hospital.district.province.province_name if hospital.district.present? and hospital.district.province.present?
		
		return data
	end


	def is_epidemiological_filters_active?
		(params[:province].present? || params[:district].present? || params[:hospital].present?)
	end

	def are_monthly_patients_filters_active?
		(params[:province].present? || params[:district].present? || params[:uc].present? || params[:month].present? || params[:year].present? || params[:tehsil].present?)
	end

	def are_user_wise_larva_filters_active?
		(params[:from].present? || params[:to].present?)
	end

	## Zero Patient Report
	def get_data_zero_patient(hospital)
		data = {}
		data[:district] = hospital.district.district_name if hospital.district.present?
		data[:category] = hospital.category
		data[:facility_type] = hospital.facility_type
		
		return data
	end

	def get_data_zero_lab_patient(lab)
		data = {}
		data[:district] = lab.district.district_name if lab.district.present?
		
		return data
	end


	def is_zero_patient_filters_active?
		(params[:province].present? || params[:district].present? || params[:hospital].present? || params[:lab].present?)
	end


	## Provisional Diagnosis UC- Wise
	def provisional_diagnosis_uc_wise(district)
		data = {}
		data[:district] = hospital.district.district_name if hospital.district.present?
	end

	def is_provisional_diagnosis_uc_wise_filters_active?
		(params[:province].present? || params[:district].present? || params[:town].present? || params[:uc].present?)
	end

	def get_category(cat_activities, act_id)
		dep_category = "N/A"
		cat_activities.each do |c|
			category = c.first 
			cat_v = c.last
			if cat_v.include?("#{act_id}")
				dep_category = category
			end
		end
		return dep_category
	end
end
