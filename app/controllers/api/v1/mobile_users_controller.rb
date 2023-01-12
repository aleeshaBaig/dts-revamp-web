class Api::V1::MobileUsersController < Api::ApplicationController
	include MobileUsersHelper
	## POST | Fetch TAGS DATA
  def change_password

    old_password = params[:old_password]
    new_password = params[:new_password]
    is_forgot = true

    if current_api_user.authenticate(old_password)
      if current_api_user.update_attributes(password: new_password, password_confirmation: new_password, is_forgot: true)
        render json: {code: 200, message: 'password has been updated!', status: true, is_forgot: true}
      else
        render json: {error: 1, code: 0, message: current_api_user.errors.full_messages.to_sentence, status: false, is_forgot: false}
      end
    else
      render json: {error: 1, code: 0, message: "Old Password did not match", status: false, is_forgot: false}
    end
  end
  ## POST | Fetch TAGS DATA
  def tags_data
    resp_data = Hash.new
		tag_categories = current_api_user.tag_categories
    user_department = current_api_user.department
    # tag_categories = TagCategory.joins("inner join user_categories uc on uc.tag_category_id = tag_categories.id").where("mobile_user_id = ?", current_api_user.id).order("m_category_id")
		tag_options = TagOption.order("m_option_id")

		#setting up requried data
		resp_data["form_options"] = tag_options.map {|k| {"option_id" => k.m_option_id, "option_name" => k.option_name}}
		resp_data["categories"] = []
    resp_data['is_optional'] = false
		tag_categories.each_with_index do |t, i|
		  cat_wise_data = Hash.new
		  cat_wise_data["category_id"] = t.m_category_id
		  cat_wise_data["category_name"] = t.category_name
      cat_wise_data["category_name_en"] = t.category_name
      cat_wise_data["category_name_ur"] = t.urdu
		  
      # tag_details = current_api_user.department.tags.exists?(tag_category_id: t.id)
      tag_details = user_department.tags.where("tag_category_id = ?", t.id)
		  cat_wise_data["tags"] = tag_details.map{|k| 
                                  {
                                    "tag_id" => is_null(k.m_tag_id),
                                    "tag" => is_null(k.tag_name.gsub(" ", "_").gsub("/", "_").downcase),
                                    "tag_name_en" => is_null(k.tag_name),
                                    "tag_name_ur" => is_null("#{k.urdu}"),
                                    "tag_image" => is_null(k.tag_image_url),
                                    "tag_options" => is_null(k.tag_options),
                                    "category_id" => is_null(k.m_category_id),
                                    "category_name" => is_null(t.category_name),
                                    "urdu" => is_null(k.urdu)
                                  }
                              }
		  resp_data["categories"] << cat_wise_data
		end

    user_resp = Hash.new
		u_towns = []
		# user_resp = @user
		user_resp["user_id"] = current_api_user.id
		user_resp["username"] = current_api_user.username
		user_resp["role"] = current_api_user.role

		current_api_user.tehsils.each do |tehsil|
      u_towns << { "town_id": tehsil.id, "town": tehsil.tehsil_name}
    end
		user_resp["towns"] =  u_towns
    user_resp["ucs"] =  Uc.order("uc_name").select("id as uc_id, uc_name, district_id, tehsil_id as town_id").as_json
		user_resp["district_id"] = current_api_user.district_id
		user_resp["district"] = current_api_user.district

    province = current_api_user.get_district.province
    user_resp["province_id"] = province.id
    user_resp["province_name"] = province.province_name

    user_resp["uc_id"] = Uc.first.id
		user_resp["uc"] = Uc.first.uc_name
		user_resp["department_id"] = current_api_user.department_id
		user_resp["department"] = current_api_user.department.try(:department_name)
    user_resp["patient_tags"] = ["workplace", "permanent", "residence"]
    user_resp["provisional_diagnosis"] = Patient::provisional_diagnoses.keys
    user_resp["surveillance_tags"] = SurveillanceTag.select("id as tag_id, name as tag_name, tag_type").order("name asc").as_json.map{|a| a.except!("id")}
		render json: {user: user_resp, data: resp_data, code: 200, message: 'success', status: true}
  end

  ## POST | Fetch HOTSPOT DATA 
  def hotspots_data
  	## initialized
  	message = "Records not found"; code = 0; status = false; hotspot_arr = []
  	resp = Hash.new

  	## query
    hotspots = Hotspot.active
										.joins(:department_tags)
										.get_tehsils(current_api_user.get_all_tehsil_ids)
										.get_departments(current_api_user.department_id)
    
    ## make json as per mobile requirements
    if hotspots.present?
			hotspots.each do |hotspot| 
				hotspot_arr << Hotspot.hotspot_json(hotspot)
			end
      message = "success"; code = 200; status = true
    end

    ## passing return objects as per response
    resp["message"] = message; resp["code"] = code; resp["status"] = status; resp["hotspot_list"] = hotspot_arr;

    render json: resp
  end

  ## POST | Fetch Patient Data
  def patients_data
    ## initialized
    message = "Records not found"; code = 0; status = false; patients_list = []; user_tehsils = []; page = params[:page].to_i; per_page = 20; place_type = params[:place_type] ||= 'residence';
    resp = Hash.new
    ## query
    if params[:town].present?
      user_tehsils << params[:town].to_i
    else
      user_tehsils = current_api_user.get_all_tehsil_ids
    end
    patients_data = Patient.select_patient_data.filters(params).get_patient_activities_non_dengue

    ## Data Return according to residence_type
    if place_type == 'residence'
      patients_data = patients_data.untagged_residence_tagged(user_tehsils)
    elsif place_type == 'workplace'
      patients_data = patients_data.untagged_workplace_tagged(user_tehsils)
    elsif place_type == 'permanent'
      patients_data = patients_data.untagged_permanent_residence_tagged(user_tehsils)
    else
      patients_data = patients_data.untagged_residence_tagged(user_tehsils)
    end

    patients_data = patients_data.ascending.paginate(:page => page, :per_page => per_page)

    ## make json and conditions as per mobile requirements
    if patients_data.present?
      patients_data.each{|patient| patients_list << Patient.untagged_generate_patient_list(patient, user_tehsils, place_type)}
      message = "success"; code = 200; status = true
    end
    
    # puts "=========================#{patients_data.as_json}"
    
    ## passing return objects as per response
    resp["message"] = message; resp["code"] = code; resp["status"] = status; resp["patients_list"] = patients_list.flatten!
    render json: resp
  end

  ## tagged patient data
  def tagged_patients
    ## initialized
    message = "Records not found"; code = 0; status = false; patients_list = []; user_tehsils = []; page = params[:page].to_i; per_page = 20; place_type = params[:place_type] ||= 'residence';
    resp = Hash.new
    ## query
    if params[:town].present?
      user_tehsils << params[:town].to_i
    else
      user_tehsils = current_api_user.get_all_tehsil_ids
    end
    patients_data = Patient.select_patient_data.filters(params).get_patient_activities_non_dengue

    ## Data Return according to residence_type
    if place_type == 'residence'
      patients_data = patients_data.tagged_residence_tagged(user_tehsils)
    elsif place_type == 'workplace'
      patients_data = patients_data.tagged_workplace_tagged(user_tehsils)
    elsif place_type == 'permanent'
      patients_data = patients_data.tagged_permanent_residence_tagged(user_tehsils)
    else
      patients_data = patients_data.tagged_residence_tagged(user_tehsils)
    end

    patients_data = patients_data.ascending.paginate(:page => page, :per_page => per_page)

    ## make json and conditions as per mobile requirements
    if patients_data.present?
      patients_data.each{|patient| patients_list << Patient.tagged_generate_patient_list(patient, user_tehsils, place_type)}
      message = "success"; code = 200; status = true
    end

    ## passing return objects as per response
    resp["message"] = message; resp["code"] = code; resp["status"] = status; resp["patients_list"] = patients_list.flatten!
    render json: resp
  end
  ############################################### OLD CODE ######################################################################
  # def patients_data
	# 	## initialized
  # 	message = "Records not found"; code = 0; status = false; patients_list = []
  # 	resp = Hash.new
  
  # 	## query
  #   user_tehsils = current_api_user.get_all_tehsil_ids
  # 	patients_data = Patient.where("created_at > ?", "03/07/2021".to_date).get_patient_activities_prov_diag.untagged_patient_data(user_tehsils)

  # 	## make json and conditions as per mobile requirements
  #   if patients_data.present?
	#     patients_data.each do |patient|
	#       patients_list << Patient.get_patient_activities_prov_diag.untagged_generate_patient_list(patient, user_tehsils)
	#     end
	#     message = "success"; code = 200; status = true
	#   end

  #   ## passing return objects as per response
  #   resp["message"] = message; resp["code"] = code; resp["status"] = status; resp["patients_list"] = patients_list.flatten!
  #   render json: resp
  # end
  ############################################## END OLD CODE ####################################################################
  
  # def tagged_patients
  #   ## initialized
  #   message = "Records not found"; code = 0; status = false; patients_list = []
  #   resp = Hash.new

  #   ## query
  #   user_tehsils = current_api_user.get_all_tehsil_ids
  #   patients_data = Patient.where("created_at > ?", "03/07/2021".to_date).get_patient_activities_prov_diag.tagged_patients(user_tehsils)

  #   ## make json and conditions as per mobile requirements
  #   if patients_data.present?
  #     patients_data.each do |patient|
  #       patients_list << Patient.tagged_generate_patient_list(patient, user_tehsils)
  #     end
  #     message = "success"; code = 200; status = true
  #   end

  #   ## passing return objects as per response
  #   resp["message"] = message; resp["code"] = code; resp["status"] = status; resp["patients_list"] = patients_list.flatten!
  #   render json: resp
  # end
end
