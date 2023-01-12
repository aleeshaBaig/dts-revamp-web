class AjaxController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def nfs_picture
    picture_url = params[:picture_url]
    begin
      send_file File.join("#{picture_url}"), :disposition => 'inline'
    rescue
      send_file File.join("/home/dentracking/dengue/public/tag_image.png")
    end
  end
  def populate_tehsil
    @tehsils = []
    @ucs = []
    if params[:district].present?
      if params[:district] != 'All'
        @tehsils = Tehsil.accessible_by(current_ability, :read).where('district_id = ?', params[:district]).order("tehsil_name ASC").collect{|p| [p.tehsil_name, p.id]}
      else
        @tehsils = Tehsil.select("id,tehsil_name").order("tehsil_name ASC").collect{|p| [p.tehsil_name]}
      end
    end

    @tehsils = @tehsils.uniq      #ignoring repeating elements

    respond_to do |format|
      format.json {render :json => @tehsils.to_json}
    end
  end

	def populate_uc
    if params[:town].present?
      if params[:town] != 'All'
        @ucs = Uc.accessible_by(current_ability, :read).where('tehsil_id = ?', params[:town].downcase).order("uc_name ASC").collect{|p| [p.uc_name,p.id]}
      else
        @ucs = Uc.select("id,uc_name").order("uc_name ASC").collect{|p| [p.uc_name]}
      end
    end

    #ignoring repeating elements
    @ucs = @ucs.uniq
    respond_to do |format|
      format.json {render :json => @ucs.to_json}
    end
  end

  def populate_p_outcome
    @outcomes = []
    if params[:status] == "Closed"
      @outcomes = [["Death","Death"],[ "Discharged", "Discharged"], ["LAMA","LAMA"]]
    elsif params[:status] == "In Process"
      @outcomes = [["Admitted","Admitted"], ["Outpatient","Outpatient"]]
    end
    respond_to do |format|
      format.json {render :json => @outcomes.to_json}
    end
  end

  def change_patient_activity_status
    Patient.where("active_status is true and created_at > ?",3.months.ago).each do |p|
      p.update_attributes(:active_status => false)
    end
  end

  def populate_division
    @divisions = []
    if params[:province_id].present?
      @divisions = Division.where('province_id = ?', params[:province_id]).order("division_name ASC").collect{|p| [p.division_name,p.id]}
    end

    @divisions = @divisions.uniq      #ignoring repeating elements

    respond_to do |format|
      format.json {render :json => @divisions.to_json}
    end
  end

  def populate_district
    @districts = []
    if params[:division_id].present?
      @districts = District.where('division_id = ?', params[:division_id]).order("district_name ASC").collect{|p| [p.district_name,p.id]}
    end

    @districts = @districts.uniq      #ignoring repeating elements

    respond_to do |format|
      format.json {render :json => @districts.to_json}
    end
  end

  def populate_province_district
    @districts = []
    if params[:province_id].present?
      @districts = District.where('province_id = ?', params[:province_id]).order("district_name ASC").collect{|p| [p.district_name,p.id]}
    else
      @districts = District.order("district_name ASC").collect{|p| [p.district_name,p.id]}
    end

    respond_to do |format|
      format.json {render :json => @districts.to_json}
    end
  end

  def populate_district_hospital
    @hospitals = []
    if params[:district_id].present?
      @hospitals = Hospital.where('district_id = ?', params[:district_id]).order("hospital_name ASC").collect{|p| [p.hospital_name,p.id]}
    else
      @hospitals = Hospital.order("hospital_name ASC").collect{|p| [p.hospital_name,p.id]}
    end

    respond_to do |format|
      format.json {render :json => @hospitals.to_json}
    end
  end

  def check_for_existing_patient
    @record = nil
    lab_patient = false
    edit_form = false
    error_form = "Yes"
    patient_status = ''
    if params[:cnic].present?
      if params[:select_type] == 'CNIC'
        patient = Patient.find_by_cnic(params[:cnic])
      else
        patient = Patient.find_by_passport(params[:cnic])
      end
      if patient.present?
        if patient.patient_outcome.present? and patient.patient_outcome == 'Death'
          error_form = "Yes"
        else
          edit_form = true
          @record = patient.id
          @record_f = patient.is_released
          patient_status =  patient.patient_status
          puts "=====#{patient_status}"
          error_form = "No"
        end
      else
        error_form = "No"
      end
    end

    render :json => { data: @record, lab_patient: lab_patient, edit_form: edit_form, patient_status:  patient_status, r_flag: @record_f, error_form: error_form}
  end

  def populate_hospital
    facility_type = params[:type] ||= params[:facility_type] ## facility_type or type both params acceptable
    
    ## where clause condition
    q_facility_type = facility_type.present? ? "facility_type = '#{facility_type}'" : true
    q_district = params[:district].present? ? "district_id = '#{params[:district]}'" : true
    q_category = params[:category].present? ? "category = '#{params[:category]}'" : true
    
    where_clause = "#{q_facility_type} and  #{q_district} and #{q_category}"
    
    ## Hospital data populate
    hospitals = Hospital.select("id, hospital_name").accessible_by(current_ability, :read)
    hospitals = hospitals.where("#{where_clause}").order("hospital_name ASC").collect{|p| [p.hospital_name,p.id]}
    hospitals = hospitals.uniq
    
    render json: hospitals.to_json
  end



  def populate_lab

    
    _dist  = params[:district].present? ? "district_id = '#{params[:district]}'" : 'true'

    # @labs = Lab.accessible_by(current_ability, :read).select(:lab_name, :id).where("#{_dist}").order("lab_name ASC").collect{|p| [p.lab_name,p.id]}
    @labs = Hospital.get_labs.accessible_by(current_ability, :read).where("#{_dist}").order('hospital_name asc').collect{|p| [p.hospital_name, p.id]}

    @labs = @labs.uniq      #ignoring repeating elements

    respond_to do |format|
      format.json {render :json => @labs.to_json}
    end
  end

  def district_town_mapping
    error = false
    response = "Successful"

    data_array = []
    Uc.includes(:district, :tehsil).find_each do |u|
      data_array << { "district" => u.district.district_name, "town" => u.tehsil.tehsil_name, "uc" => u.uc_name, "uc_no" => u.uc_name }
    end

    @result = data_array
    fac_str = '{"facilityType":[{"typeId":"0","displayName":"Government Dispensary","systmeName":"GOV_DIS"},{"typeId":"1","displayName":"BHU","systmeName":"BHU"},{"typeId":"2","displayName":"DHQ","systmeName":"DHQ"},{"typeId":"10","displayName":"Other","systmeName":"OTHER"}]}'

    respond_to do |format|
      format.js {render :json => {:district => @result, :facilities => fac_str, :response_message => response, :error => error.to_json} }
    end
  end

  ## Authentication GP USER
  def auth_app_user
    p_username = params[:username].try(:downcase)
    p_password = params[:password].try(:downcase)
    gp_user = GpUser.where("lower(email) =? and lower(password) =?", "#{p_username}", "#{p_password}").last
    if gp_user.present?
      response = {status: 1, message: "success", code: 200, data: gp_user.to_json}
    else
      response = {status: 0, message: "Username or password are invalid", code: 404}
    end
    render json: response.to_json
  end

  ## Register GP USER
  def self_registration
    data = params[:data]

    if data.present?
      data_parse = JSON.parse(data.to_json)
      data_obj = {
        name: "#{data_parse['username']}",
        email: "#{data_parse['email']}",
        password: "#{data_parse['password']}",
        facility_type: "#{data_parse['facility_type']}",
        district: "#{data_parse['district']}",
        address: "#{data_parse['address']}",
        city_name: "#{ data_parse['city_name']}",
        contact_no: "#{data_parse['contact']}",
        division: "#{data_parse['division']}",
        doctor_name: "#{data_parse['doctor_name']}",
        hospital: "#{data_parse['hospital']}",
        is_mobile_signup: true,
        lat: "#{data_parse['lat']}",
        lng: "#{data_parse['lng']}",
        pmdc_number: "#{data_parse['pmdc_number']}",
        tehsil: "#{data_parse['tehsil']}"
      }
      gp_user = GpUser.new(data_obj)

      if gp_user.save
        response = {status: true, message: "success", code: 200, data: data_obj}
      else
        response = {status: false, message: "#{gp_user.errors.full_messages}", code: 404}
      end
    else
      response = {status: false, message: "Invalid parameters", code: 404}
    end
    render json: response.to_json
  end

  def gp_patients_list
    @tehsils = []
    message = ""
    error = false

    if params[:user_id].present?
      @patients = GpPatient.where("gp_user_id = ? and created_at > ?", params[:user_id], 7.days.ago)
      message = "Successful"
    else
      message = "User parameter not found"
      error = true
    end

    @patients = @patients.uniq      #ignoring repeating elements

    respond_to do |format|
      format.js {render :json => {:list_patients => @patients, :response_message => message, :error => error.to_json} }
    end
  end

  def disease_reporting_system
    response = nil
    dis_id = nil
    town_id = nil
    uc_id = nil
    
    if params['district'].present?
      district = District.select("id").where("district_name like ?", params['district']).last
      dis_id = district.try(:id)
    end
    if params['town'].present?  
      town = Tehsil.select("id").where("tehsil_name like ?", params['town']).last
      town_id = town.try(:id)
    end
    if params['uc'].present?
      uc = Uc.select("id").where("uc_name like ?", params['uc']).last
      uc_id = uc.try(:id)
    end

    if params['gp_patient_id'].present?

      gp_patient = GpPatient.find_by_id params['gp_patient_id']
      
      dengue_patient_data = {
        reporting_date: params['date'],
        patient_name: params['pname'],
        fh_name: params['pfhname'],
        dob: params['dob'],
        age: (Time.parse(params['dob']).try(:year) rescue nil),
        age_month: (Time.parse(params['dob']).try(:month) rescue nil),
        gender: params['gender'],
        cnic: params['cnic'],
        phone_number: params['contact'],
        district: params['district'],
        town_tehsil: params['town'],
        uc_name: params["uc"],
        district_id: dis_id,
        tehsil_id: town_id,
        uc_id: uc_id,
        occupation: params["profession"],
        lat: params['lat'],
        long: params['long'],
        onset_date_fever: params["dateOfOnSetFever"],
        prev_dengue_fever: params["previousHoFever"],
        fever: params["dengueFeverDuration"],
        warning_signs: params["apperanceWarningSign"],
        provisional_diagnosis: params["provisinalDignosis"],
        igg_performed: params["iggPerformed"],
        igm_performed: params["igmPerformed"],
        antigen_performed: params["ns1AntigenPerformed"],
        wbc_first_reading: params["mm3"],
        wbc_first_date: params["wbc1ReadingDate"],
        dengue_type: params["seroType"],
        diagnosis: params["dignosis"],
        patient_status: params["patientStatus"],
        comments: params["comments"],
        is_app_user: true,
        residence_address: params["addressResidence"],
        workplace_address: params["workPlace"],
        headache: params["Headache"],
        retro_orbital_pain: params["Retro_Orbital_Pain"],
        myalgia: params["Myalgia"],
        arthralgia_backache: params["Arthralgia_Svere_Backache_Bone_Pains"],
        irritability_in_infants: params["irritability_in_infants"],
        rash: params["Rash"],
        bleeding_manisfestations: params["Bleeding_Manifestations"],
        severe_abdominal_pain: params["Sever_Abdominal_Pain"],
        decreased_urinary_output: params["Decreased_Urinary_Output_Despite_Adequate_fluid_Intake"],
        temprature: params["Temperature"],
        hr: params["HR"],
        bp_s: params["BP_S"],
        bp_d: params["BP_D"],
        platelets_date: params["platletesReadingDate"],
        platelets_reading: params["platletesReading"],
        reffer_to: params["ReferHospitalForProbable"],
        refered_to_confirmed: params["ReferHospitalForConfirmed"],
        probable_patient_status: params["probable_patientStatus"],
        probable_comments: params["probable_comments"],
        present_address: params["addressPresent"],
        residence_address: params["addressPermanent"],
        has_fever: params["fever"],
        pp: params["PP"],
        wbc1lessthan4000: params["wbc1LessThan4000"],
        platelets_less_than_lakh: params["platletesLessThan100000"],
        no_clinical_improvement: params["noClinicalImprovement"],
        persistent_vomiting: params["PersistentVomiting"],
        severe_abdominal_pain: params["SevereAbdominalPain"],
        lethargy_restlessness: params["lethargyAndOrRestlessness"],
        giddiness: params["Giddiness"],
        clammy_extremities: params["PaleColdClammyExtremities"],
        bleeding_epistaxis: params["Bleeding_Epistaxis_GumBleed_Bloody_Stools"],
        hematemesis: params["hematemesis_hemoptysis_menorrhagia_hematuria"],
        hct: params["HCT"],
        pulse_pressure: params["PulsePressure"],
        no_urine_output: params["NoUrineOutputFor4to6Hours"],
        ns1_reading_date: params["NS-1ReadingDate"],
        detection_by_pcr: params["DetectionBy_PCR"],
        pcr_detection_date: params["PCR_DetectionDate"],
        igm_reading_date: params["igmReadingDate"],
        igg_reading_date: params["iggReadingDate"],
        df: params["DF"],
        dhf: params["DHF"],
        dss: params["DSS"]
      }

      if gp_patient.present?
        gp_patient.attributes = dengue_patient_data
        if dengue_patient.save
          response = {status: 1, message: "successfully updated",error: 'null'}
        else
          response = {status: 0, message: "#{dengue_patient.errors.full_messages}",error: true}
        end
      else
        response = {status: 0, message: "patient not found",error: true}
      end
    else

      dengue_patient_data = {
        gp_user_id: params['user_id'],
        reporting_date: params['date'],
        patient_name: params['pname'],
        fh_name: params['pfhname'],
        dob: params['dob'],
        age: (Time.parse(params['dob']).try(:year) rescue nil),
        age_month: (Time.parse(params['dob']).try(:month) rescue nil),
        gender: params['gender'],
        cnic: params['cnic'],
        phone_number: params['contact'],
        district: params['district'],
        town_tehsil: params['town'],
        uc_name: params["uc"],
        district_id: dis_id,
        tehsil_id: town_id,
        uc_id: uc_id,
        occupation: params["profession"],
        lat: params['lat'],
        long: params['long'],
        onset_date_fever: params["dateOfOnSetFever"],
        prev_dengue_fever: params["previousHoFever"],
        fever: params["dengueFeverDuration"],
        warning_signs: params["apperanceWarningSign"],
        provisional_diagnosis: params["provisinalDignosis"],
        igg_performed: params["iggPerformed"],
        igm_performed: params["igmPerformed"],
        antigen_performed: params["ns1AntigenPerformed"],
        wbc_first_reading: params["mm3"],
        wbc_first_date: params["wbc1ReadingDate"],
        dengue_type: params["seroType"],
        diagnosis: params["dignosis"],
        patient_status: params["patientStatus"],
        comments: params["comments"],
        is_app_user: true,
        residence_address: params["addressResidence"],
        workplace_address: params["workPlace"],
        headache: params["Headache"],
        retro_orbital_pain: params["Retro_Orbital_Pain"],
        myalgia: params["Myalgia"],
        arthralgia_backache: params["Arthralgia_Svere_Backache_Bone_Pains"],
        irritability_in_infants: params["irritability_in_infants"],
        rash: params["Rash"],
        bleeding_manisfestations: params["Bleeding_Manifestations"],
        severe_abdominal_pain: params["Sever_Abdominal_Pain"],
        decreased_urinary_output: params["Decreased_Urinary_Output_Despite_Adequate_fluid_Intake"],
        temprature: params["Temperature"],
        hr: params["HR"],
        bp_s: params["BP_S"],
        bp_d: params["BP_D"],
        platelets_date: params["platletesReadingDate"],
        platelets_reading: params["platletesReading"],
        reffer_to: params["ReferHospitalForProbable"],
        refered_to_confirmed: params["ReferHospitalForConfirmed"],
        probable_patient_status: params["probable_patientStatus"],
        probable_comments: params["probable_comments"],
        present_address: params["addressPresent"],
        residence_address: params["addressPermanent"],
        has_fever: params["fever"],
        pp: params["PP"],
        wbc1lessthan4000: params["wbc1LessThan4000"],
        platelets_less_than_lakh: params["platletesLessThan100000"],
        no_clinical_improvement: params["noClinicalImprovement"],
        persistent_vomiting: params["PersistentVomiting"],
        severe_abdominal_pain: params["SevereAbdominalPain"],
        lethargy_restlessness: params["lethargyAndOrRestlessness"],
        giddiness: params["Giddiness"],
        clammy_extremities: params["PaleColdClammyExtremities"],
        bleeding_epistaxis: params["Bleeding_Epistaxis_GumBleed_Bloody_Stools"],
        hematemesis: params["hematemesis_hemoptysis_menorrhagia_hematuria"],
        hct: params["HCT"],
        pulse_pressure: params["PulsePressure"],
        no_urine_output: params["NoUrineOutputFor4to6Hours"],
        ns1_reading_date: params["NS-1ReadingDate"],
        detection_by_pcr: params["DetectionBy_PCR"],
        pcr_detection_date: params["PCR_DetectionDate"],
        igm_reading_date: params["igmReadingDate"],
        igg_reading_date: params["iggReadingDate"],
        df: params["DF"],
        dhf: params["DHF"],
        dss: params["DSS"]
      }

      dengue_patient = GpPatient.new(dengue_patient_data)

      if dengue_patient.save
        response = {status: 1, message: "successfully created",error: 'null'}
      else
        response = {status: 0, message: "#{dengue_patient.errors.full_messages}",error: true}
      end
    end
    render json: response.to_json
  end
  
def google_map_popup_data
    # puts "==========#{params[:activity_id]}"
    # puts "==========#{params[:activity_type]}"
    if params[:activity_type] == 'patient_activity'
      @activity = PatientActivity.find(params[:activity_id])
    else
      @activity = SimpleActivity.find(params[:activity_id])
    end
    render layout: 'map_popup'
  end
  def tpv_popup_data
    @activity = []
    if params[:activity_id].present?
      @activity_id = params[:activity_id].to_i

      @username = "anonymous"

      if params[:type] == "cr"
        @activity = PatientAudited.find(params[:activity_id])
        @job_id = @activity.patient_activity_id
        @p_type = "Patient"
      elsif params[:type] == "rest"
        @activity = LarvaeAudited.find(params[:activity_id])
        @job_id = @activity.simple_activity_id
        @p_type = "Larvae"
      elsif params[:type] == "indoor" or params[:type] == "outdoor"
        @activity = SurveillanceAudit.find(params[:activity_id])
        @job_id = @activity.simple_activity_id
        @p_type = "Surveillance"
      end

      user = MobileUser.find(@activity.mobile_user_id)
      if user.present?
        @username = user.username
      end
    end
    
    render layout: 'map_popup'
  end  
end
