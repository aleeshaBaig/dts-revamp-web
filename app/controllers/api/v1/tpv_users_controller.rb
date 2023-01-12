class Api::V1::TpvUsersController < Api::ApplicationController
  ### >>>>>>>>>>>>>
	## Save Audit Patient
	### <<<<<<<<<<<<<
  before_action :get_location, except: :get_audit_activity
  def get_location
    if params[:location].present?
      @lat, @long = params[:location].split(",")
    else
      render json: {:status => false, :message => 'Location Not Found', error: 1}
    end
  end

  def save_audit_patient
    message = ""
    status = false
    error = 1

    params[:sopFollowed] = params[:sopFollowed].present? ? (params[:sopFollowed].to_i == 1 ? true : false) : nil
    params[:findLarvae] = params[:findLarvae].present? ? (params[:findLarvae].to_i == 1 ? true : false) : nil
    params[:isConductedAtPlace] = params[:isConductedAtPlace].present? ? (params[:isConductedAtPlace].to_i == 1 ? true : false) : nil
    params[:conductionPlace] = params[:conductionPlace].present? ? (params[:conductionPlace].to_i == 1 ? true : false) : nil

    patient_audited = PatientAudited.new(:mobile_user_id => current_api_user.id, :app_version => params[:appVersion], :location => params[:location], :lat => @lat, :lng => @long, :conduction_place => params[:conductionPlace], :sop_followed => params[:sopFollowed], :comments => params[:comments], :response_conducted_at_place => params[:isConductedAtPlace], :patient_activity_id => params[:jobId].to_i, visited_before:  params[:visitedBefore].try(:to_i), visit_adjacent_house: params[:visitAdjacenthouse], chemical_option: params[:chemicalOption], larvaciding_conducted: params[:LarvacidingConducted].try(:to_i), mechanical_option: params[:mechanicalOption], biological_selected: params[:biologicalSelected].try(:to_i), larva_found_from: params[:larvaFoundFrom], chemical_selected: params[:chemicalSelected].try(:to_i), awareenss_session: params[:awareenssSession], mechanical_selected: params[:mechanicalSelected].try(:to_i),  last_visited: params[:lastVisited],  supervisor_visited: params[:supervisorVisited], :larvae_found => params[:findLarvae])
    if patient_audited.save
      if params[:picture].present?
        #back_before_create_async(params[:picture_before],@activity)
        picture = patient_audited.create_picture(:before_picture => params[:picture], pictureable_tag: "audit_patient")
        patient_audited.update_attributes( :picture_url => picture.before_picture.url )
      end
      message = "Patient Audit Saved"
      status = true
      error = 0
    else
      message = "#{patient_audited.errors.messages}"
    end

    render json: {:status => status.to_json, :message => message, error: error}
  end
	
	### >>>>>>>>>>>>>
	## Save Audit Larvae
	### <<<<<<<<<<<<<
  def save_audit_larvae
    message = ""
    status = false
    error = 1

    params[:larvaFound] = params[:larvaFound].present? ? (params[:larvaFound].to_i == 1 ? true : false) : nil
    params[:larvaFoundEarlier] = params[:larvaFoundEarlier].present? ? (params[:larvaFoundEarlier].to_i == 1 ? true : false) : nil

    
    larvae_audited = LarvaeAudited.new(:mobile_user_id => current_api_user.id, :app_version => params[:appVersion], :location => params[:location], :lat => @lat, :lng => @long, :larvae_found => params[:larvaFound], :larvae_found_before => params[:larvaFoundEarlier], :larviciding => params[:larvaciding], :remarks => params[:remarksByVerifier], :larviciding_type => params[:larvacidingType], :simple_activity_id => params[:jobId].to_i, visited_before:  params[:visitedBefore].try(:to_i), visit_adjacent_house: params[:visitAdjacenthouse], chemical_option: params[:chemicalOption], larvaciding_conducted: params[:LarvacidingConducted].try(:to_i), mechanical_option: params[:mechanicalOption], biological_selected: params[:biologicalSelected].try(:to_i), larva_found_from: params[:larvaFoundFrom], chemical_selected: params[:chemicalSelected].try(:to_i), awareenss_session: params[:awareenssSession], mechanical_selected: params[:mechanicalSelected].try(:to_i),  last_visited: params[:lastVisited],  supervisor_visited: params[:supervisorVisited], :comments => params[:generalRemarks])

    if larvae_audited.save
      if params[:picture].present?
        #back_before_create_async(params[:picture_before],@activity)
        picture = larvae_audited.create_picture(:before_picture => params[:picture], pictureable_tag: "audit_larvae")
        larvae_audited.update_attributes( :picture_url => picture.before_picture.url )
      end
      message = "Larvae Audit Saved"
      status = true
      error = 0
    else
      message = "#{larvae_audited.errors.messages}"
    end
    
    render json: {:status => status.to_json, :message => message, error: error}
  end  

	### >>>>>>>>>>>>>
	## Save Audit Surveillance
	### <<<<<<<<<<<<<
  
  def save_audit_surveillance
    message = ""
    status = false
    error = 1

    params[:larva_found] = params[:larva_found].present? ? (params[:larva_found].to_i == 1 ? true : false) : nil
    params[:rooftop] = params[:rooftop].present? ? (params[:rooftop].to_i == 1 ? true : false) : nil
    params[:material] = params[:material].present? ? (params[:material].to_i == 1 ? true : false) : nil
    params[:visited_before] = params[:visited_before].present? ? (params[:visited_before].to_i == 1 ? true : false) : nil
    params[:surveillance_type] = params[:surveillance_type].present? ? (params[:surveillance_type].to_i == 1 ? true : false) : nil

    surveillance_audit = SurveillanceAudit.new(:mobile_user_id => current_api_user.id, :app_version => params[:app_version], :location => params[:location], :lat => @lat.to_f, :lng => @long.to_f, :larvae_found => params[:larva_found], :larvae_found_earlier => params[:larva_found_earlier], :remarks => params[:remarks], visited_before:  params[:visited_before], :no_of_containers_checked => params[:containers].try(:to_i), :rooftop_checked => params[:rooftop], :material_provided => params[:material], :is_indoor => params[:surveillance_type], :time_taken => params[:time_taken], simple_activity_id: params[:job_id])
    if surveillance_audit.save
      if params[:picture].present?
        #back_before_create_async(params[:picture_before],@activity)
        picture = surveillance_audit.create_picture(:before_picture => params[:picture], pictureable_tag: "audit_surveillance")
        surveillance_audit.update_attributes( :picture_url => picture.before_picture.url )
      end
      message = "Surveillance Audit Saved"
      status = true
      error = 0
    else
      message = "Surveillance Audit not saved"
    end

    render json: {:status => status.to_json, :message => message, error: error}
  end

	### >>>>>>>>>>>>>
	## Save Audit Activity
	### <<<<<<<<<<<<<

  def get_audit_activity
    message = ""
    status = false
    error = 1
    # Parameter Type LEGEND
    # TYPE_SURVEILLANCE_INDOOR = "1"
    # TYPE_SURVEILLANCE_OUTDOOR = "0"
    # TYPE_LARVAE = "2"
    # TYPE_PATIENT = "3"
    q_type = "true"
    if params[:type].present?
      if params[:type] == "0"
        q_type = "io_action = '1' and larva_found is not true AND tag_name != 'Patient Irs'"
      elsif params[:type] == "1"
        q_type = "io_action = '0' and larva_found is not true AND tag_name != 'Patient Irs'"
      elsif params[:type] == "2"
        q_type = "larva_found is true" ## larvae is positive
      elsif params[:type] == "3"
        q_type = "tag_name = 'Patient Irs' and patient_place = '2'"
      elsif params[:type] == "4"
        q_type = "tag_name = 'Patient Irs' and patient_place = '1'"
      end
    end

    activities_data = []
    if params[:jobId].present?
      if ["3","4"].include?(params[:type])
        activities = PatientActivity.select("id, description, tehsil_name, uc_name, latitude as lat, longitude as lng, tag_name, patient_id, patient_place").where("id = ? and #{q_type}", params[:jobId].to_i).last
      else
        activities = SimpleActivity.select("id, description, tehsil_name, uc_name, latitude as lat, longitude as lng, tag_name").where("id = ? and #{q_type}", params[:jobId].to_i).last
      end
      
      if activities.present?
        activities_data << activities
        status = true
        message = "Successful"
        error = 0
      else
        message = "ID not found against given category"
      end
    else
      message = "Job Id are missing Missing"
      error = 1
    end

    render json: {:data => activities_data.to_json, :message => message, :status => status.to_json, error: error}
  end
end