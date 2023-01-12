module ApplicationHelper
	def larvae_types
		{"positive"=>0, "negative"=>1, "repeat" => 2}
	end
	def per_page_items(items = 1000000)
		(params[:pagination] == "No" or request.format == "xls") ? items : 20
	end
	def default_home_path
		if current_user.admin?
        	patients_path
		elsif (current_user.hospital_user? or current_user.hospital_supervisor?)
			home_hospital_users_path
		elsif (current_user.lab_user? or current_user.lab_supervisor?)
			home_lab_users_path
		elsif current_user.provisional_incharge?
			home_provincial_path
		elsif current_user.department_user?
			heat_map_path
		elsif current_user.tehsil_user?
			summary_of_activities_town_wise_path
		else
			patients_path
		end
	end
	def audit_types
		{
			"rest" => "Positive Larvae", 
			"cr" => "Case Response", 
			"indoor" => "Surveillance (Indoor)", 
			"outdoor" => "Surveillance (Outdoor)"
		}
	end
	def _get_u_towns_(district_id = nil)  
		data = district_id.present? ? Tehsil.where(district_id: district_id).order(:tehsil_name) : []
		return data
	end
	def tag_categories_list
		tag_categories = []
		tag_categories = TagCategory.order("category_name").collect{|tag_category| [tag_category.category_name, tag_category.id]}
		return tag_categories
	end
	def tag_list

		tags = []
		tags = Tag.order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		return tags
	end

	def patient_tag_list
		tags = []
		if current_user.department_user?
			tags = Tag.joins(:departments).where("departments.id = ?",current_user.department_id).order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		else
			tags = Tag.where("m_category_id = ?", 2).order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		end
		return tags
	end

	def non_patient_tag_list
		tags = []
		tags = Tag.where("m_category_id != ?",2).order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		return tags
	end

	def vector_surveillance_tag_list
		tags = []
		tags = Tag.where("tag_name IN(?)",['Indoor', 'Outdoor']).order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		return tags
	end

	def hotspot_tags
		tags = []
		tags = Tag.where("m_category_id = ?", 1).order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		return tags
	end

	def allied_departments
		deps = []
		deps = Department.where("department_type = ?", "Allied").order(:department_name).collect{|dep| [dep.department_name, dep.id]}
		return deps
	end

	def dco_departments
		deps = []
		deps = Department.where("department_type = ?", "DCO").order(:department_name).collect{|dep| [dep.department_name, dep.id]}
		return deps

	end

	def departments_list
		departments = []
	  departments = Department.accessible_by(current_ability).order("department_name").collect { | dep | [dep.department_name, dep.id] }
	  return departments
	end
	def guardians_relations
		return ["Brother", "Daughter","Father", "Grand Child", "Grand Parent","Mother", "Sister", "Son", "Spouse", "Other", "Self"]
	end
	def genders
		["Male", "Female", "Other"]
	end	
	def all_provinces
	  provinces = []
	  provinces = Province.order("province_name").collect { | prov | [prov.province_name, prov.id] }
	  return provinces
	end

	def hospital_categories
		# ["Government", "P&SHD", "Private", "SHC&MED"]
		["Government", "P&SHD", "Private", "SHC&MED", "Lab"].sort.uniq
	end
	def hospital_category
		if current_user.phc_user?
			["Lab", "Private"]
		else
			hospital_categories # return ["Private","Public", "Home", "Lab"].push(hospital_categories).flatten!.sort.uniq
		end
	end
	def medicine_names
		["Dextron-40", "Paracetamol", "IV-Fluids"]
	end

	def ppe_names
		["Mosquito Nets", "IgM", "IgG", "NS1 Rapid", "NS1 Elisa", "CBC Analyzer"]
	end

	def insecticide_names
		["Alphacypermethrin", "Deltamethrin", "Lambda Cyhalothrin", "Temephos"]
	end

	def facility_type
		if current_user.phc_user?
			["Lab", "Private"]
		else 
			["Government", "BHU", "RHC", "THQ", "Private", "Social Security", "DHQ", "Teaching Hospital", "Tertiary Hospital", "Home", "Lab"].sort
		end
		# facility_type = Hospital.select('distinct facility_type').order("facility_type ASC").collect { | hosp | [hosp.facility_type] }
		# return facility_type
	end

	def lab_type
		return ["Private","Public", "Home"]
	end

	def province_wise_divisions(prov_id)
		if prov_id.present?
			divisions = Division.where("province_id = #{prov_id}").order("division_name").collect { | div | [div.division_name, div.id] }
			return divisions
		else
			return []
		end
	end

	def all_divisions
	  divisions = []
	  if params[:province_id].present?
	  	divisions = Division.order("division_name").where("province_id = ?",params[:province_id]).collect { | divi | [divi.division_name, divi.id] }
	  else
	  	divisions = Division.order("division_name").collect { | divi | [divi.division_name, divi.id] }
	  end
	  return divisions
	end

	def all_districts
		districts = []
		if params[:province_id].present? and params[:division_id].present?
			districts = District.select('id, district_name').accessible_by(current_ability).where("province_id = ? and division_id = ?",params[:province_id],params[:division_id]).order('district_name asc').collect { | dist | [dist.district_name, dist.id] }
		else
	    	districts = District.select('id, district_name').accessible_by(current_ability).order('district_name asc').collect { | dist | [dist.district_name, dist.id] }
	  end
	  return districts
	end

	def district_wise_labs
		labs = []
		if params[:district].present?
			labs = Lab.select('id, lab_name').accessible_by(current_ability).where("district_id = ?",params[:district]).order('lab_name asc').collect { | lab | [lab.lab_name, lab.id] }
		else
	    	labs = Lab.select('id, lab_name').accessible_by(current_ability).order('lab_name asc').collect { | lab | [lab.lab_name, lab.id] }
	  	end
	  return labs
	end

	def district_information(province_id)
  	province_q = province_id.present? ? "province_id = '#{province_id}'" : 1 == 2
  	districts = District.select('id, district_name').where("#{province_q}").order('district_name').collect { | dis | [dis.district_name, dis.id] }
  	return districts
	end

	def tehsil_information(district)
    	district_q = district.present? ? "district_id = '#{district}'" : 1==2
    	tehsils = Tehsil.accessible_by(current_ability).select('id, tehsil_name').where("#{district_q}").order('tehsil_name').collect { | teh | [teh.tehsil_name, teh.id] }
    	return tehsils
  	end

  	def ucs_information(tehsil)
    	tehsil_q  = tehsil.present? ? "tehsil_id = '#{tehsil}'" : 1 == 2
    	ucs = Uc.select("id,uc_name").where("#{tehsil_q}").collect { | uc | [uc.uc_name, uc.id] }
    	return ucs
  	end

  	def all_months
  		return [["January","1.0"],["February","2.0"],["March","3.0"],["April","4.0"],["May","5.0"],["June","6.0"],["July","7.0"],["August","8.0"],["September","9.0"],["October","10.0"],["November","11.0"],["December","12.0"]]
  	end

  	def all_departments
  		depts = []
  		depts = Department.accessible_by(current_ability).select("id,department_name").collect { | d | [d.department_name, d.id] }
  		return depts
  	end

  	def all_years
		years = []
		(2010..Time.now.year).each{|d| years << [d, d.to_f]}
  	 	return years
  		
  	end

	def all_hospital_names
	  hospitals = []
	  category_params = params[:category].present? ? "hospitals.category = '#{params[:category]}'" : true
	  facility_type_params = (params[:facility_type].present? and params[:facility_type] != 'All') ? "hospitals.facility_type = '#{params[:facility_type]}'" : true
	  hospitals = Hospital.where("#{category_params} and #{facility_type_params}").order("hospital_name").collect { | hosp | [hosp.hospital_name,hosp.id] }
	  return hospitals
	end

	def all_hospitals
		district_id = params[:district_id]
		hospitals = []
		if district_id.present?
			hospitals = Hospital.where("district_id = ?", district_id).order("hospital_name").collect { | hosp | [hosp.hospital_name,hosp.id] }
		else
			hospitals = Hospital.order("hospital_name").collect { | hosp | [hosp.hospital_name,hosp.id] }
	  end
	  return hospitals
	end

	def hospital_information(district_id)
  	district_q = district_id.present? ? "district_id = '#{district_id}'" : 1 == 2
  	hospitals = Hospital.select('id, hospital_name').where("#{district_q}").order('hospital_name').collect { | hos | [hos.hospital_name, hos.id] }
  	return hospitals
	end

	def hospital_information_prov_dashboard(district_id,facility)
  	district_q = district_id.present? ? "district_id = '#{district_id}'" : "true"
  	facility_q = facility.present? ? "facility_type = '#{facility}'" : "true"
  	hospitals = Hospital.select('id, hospital_name').where("#{district_q} and #{facility_q}").order('hospital_name').collect { | hos | [hos.hospital_name, hos.id] }
  	return hospitals
	end

	def user_wise_hospitals
		district_params = params[:district] ||= params[:district_id]
		district_q  = district_params.present? ? "district_id = '#{district_params}'" : "true"
		ftype_q  = params[:facility_type].present? ? "facility_type = '#{params[:facility_type]}'" : "true"

		if district_params.present? or params[:facility_type].present?
			hospitals = Hospital.select("id, hospital_name").accessible_by(current_ability).where("#{district_q} and #{ftype_q}").order("hospital_name").collect { | hospital | [hospital.hospital_name, hospital.id] }
		else
			if current_user.epc_user? or current_user.admin?
				hospitals = Hospital.select("id, hospital_name").where("#{district_q} and #{ftype_q}").order("hospital_name").collect { | hospital | [hospital.hospital_name, hospital.id] }
			else
				hospitals = []
			end
		end
		
		return hospitals
	end

	def get_truefalse(x)
		return x = nil if x.nil? || x == ''
		return x.titleize == 'Yes' ? true : false 
	end
	def get_yesno(x)
		return x = nil if x.nil? || x == ''
		return x == true ? 'Yes' : 'No'
	end
	def include_larva_types(type)
		SimpleActivity::larva_types.keys.include?(type) ? type : ''
	end
	def include_io_action(type)
		SimpleActivity::io_actions.keys.include?(type) ? type : ''
	end
	def remove_coma(val)
		val.present? ? (val.gsub(",", "").to_i) : 0
	end
	def delimates_coma(val)
		val.present? ? (ActiveSupport::NumberHelper.number_to_delimited(val, delimiter: ",")) : 0
	end
	def date(date)
		date.try(:strftime, '%d-%m-%Y')
	end
	def datetime(datetime)
		Time.parse("#{datetime}").try(:strftime, '%m/%d/%Y %I:%M %p %Z') rescue "- - -"
	end
end
