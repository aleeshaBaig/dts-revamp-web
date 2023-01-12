class DashboardController < ApplicationController
  layout 'adminpanel'
  before_action :set_date_default, only: [:case_response_evidence, :combined_map, :audit_map]
  before_action :set_datetime_default, only: [:heat_map]
  include ApplicationHelper
  def set_date_default
    unless params[:from].present? and params[:to].present?
      params[:from] = 1.days.ago.to_date.strftime("%Y-%m-%d")
      params[:to] = Time.now.end_of_day.to_date.strftime("%Y-%m-%d")
    end
  end
  def set_datetime_default
    unless params[:datefrom].present? and params[:dateto].present?
      params[:datefrom] = 1.days.ago
      params[:dateto] = Time.now.end_of_day.to_date.strftime("%Y-%m-%d")
    end
  end
  def case_response_evidence
    authorize! :case_response_evidence, Patient
   
    @per_page = 1000
    @activities = []
    if params[:search].present?
      patient_activities = PatientActivity.select("id, latitude, longitude, patient_place, provisional_diagnosis, tag_name").accessible_by(current_ability).case_response_tags.filters(params)
      @activities = patient_activities.order("patient_activities.id desc").paginate(:per_page => @per_page , :page => params[:page])
      
      ## Total Entries Count
      @total = (@activities.total_entries)
      @numberofpages = (@total/@per_page.to_f).ceil
      respond_to do |format|
        format.html
        format.js {
          render :json => {
            :activities => @activities,
            :from => params[:date_from].try(:strftime, "%d-%m-%Y"),
            :to => params[:date_to].try(:strftime, "%d-%m-%Y")        
          } 
        }
      end
    end



  end

	def audit_map
		@per_page = 2000
		@activities = []

    ## Default Set Positive Larvae
    params[:type] = "rest" unless params[:type].present?


		if params[:type].present? and params[:type] == "rest"
			@activities = LarvaeAudited.joins(:simple_activity).filters(params).paginate(:page => params[:page], :per_page => @per_page)

		elsif params[:type].present? and params[:type] == "cr"
			@activities = PatientAudited.joins(:patient_activity).filters(params).paginate(:page => params[:page], :per_page => @per_page)
		
    elsif params[:type].present? and params[:type] == "indoor" 
			@activities = SurveillanceAudit.joins(:simple_activity).filters(params).filter_by_indoor_outdoor(true).paginate(:page => params[:page], :per_page => @per_page)
    elsif params[:type].present? and params[:type] == "outdoor"
      @activities = SurveillanceAudit.joins(:simple_activity).filters(params).filter_by_indoor_outdoor(false).paginate(:page => params[:page], :per_page => @per_page)
		end

    # puts "=======#{@activities.count}"

    ## Total Entries Count
    @total = (@activities.total_entries)
    @numberofpages = (@total/@per_page.to_f).ceil
    respond_to do |format|
      format.html
      format.js {
        render :json => {
          :activities => @activities,
          :from => params[:date_from].try(:strftime, "%d-%m-%Y"),
          :to => params[:date_to].try(:strftime, "%d-%m-%Y")        
        } 
      }
    end
	end


  def combined_map
    authorize! :combined_map, Patient
    @per_page = 20000

    ## for ajax purpose split tag loads handled in controller not in js
    if params[:tag_load].present?
      params[:tag] = params[:tag_load].split(',').reject(&:empty?)
    elsif params[:tag_id].present?
      (params[:tag_id] = params[:tag_id].reject(&:empty?))
    elsif params[:tag].present?
      (params[:tag_id] = params[:tag].reject(&:empty?))
    end
    
     
    @activities_simple = []
    @activities_patient = []

    ### LARVAE FOUND 
    @simple_activities = SimpleActivity.select("id, latitude, longitude, io_action, larva_type").filters(params).ascending.is_larva_found.all_larvae

    ## pagination
    @activities_simple = @simple_activities.paginate(:page => params[:page], :per_page => @per_page)

    ## END LARAVE FOUND



    ## PATIENT ACTIVITIES
    @patient_activities = PatientActivity.select("id, latitude, longitude, patient_place").filters(params).ascending.is_confirmed
    @activities_patient = @patient_activities.paginate(:page => params[:page], :per_page => @per_page)

    
    ## Total Entries Count
    @total = (@activities_simple.total_entries + @activities_patient.total_entries)
    @numberofpages = (@total/@per_page.to_f).ceil
    
    respond_to do |format|
      format.html
      format.js {
        render :json => {
          :simple_activities => @activities_simple,
          :activities_patient => @activities_patient,
          :from => params[:date_from].try(:strftime, "%d-%m-%Y"),
          :to => params[:date_to].try(:strftime, "%d-%m-%Y")        
        } 
      }
    end
  end

  def heat_map
    authorize! :heat_map, SimpleActivity
    @per_page = 10000

    if params[:tag_load].present?
      params[:tag_id] = params[:tag_load].split(',').reject(&:empty?)
    else
      (params[:tag_id] = params[:tag_id].reject(&:empty?)) if params[:tag_id].present?
    end

    @activities  = SimpleActivity.accessible_by(current_ability).select("id, latitude, longitude,tag_id,uc_id").filters(params).order("simple_activities.created_at asc").paginate(:page => params[:page], :per_page => @per_page)

    @marker = "red-pin.png"
    
    # if params[:page].present?
    #   @current_page = params[:page].to_i + 1
    # else
    #   @current_page = 2
    # end
    @total = @activities.total_entries
    @numberofpages = (@total/@per_page.to_f).ceil

    
    respond_to do |format|
      format.html # result.html.erb
      format.json { render json: @activities }
    end
  end

  def home_hospital_users
    params[:d_from] = 1.day.ago.to_date  unless params[:d_from].present?
    params[:d_to] = Time.now.to_date      unless params[:d_to].present?
    
  	@total_registered_patients = Patient.accessible_by(current_ability).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).where("hospital_id = #{current_user.hospital.id}").count
  	@total_deaths = Patient.accessible_by(current_ability).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).where("patient_outcome = ?", 1).group("patient_outcome").count
  	@total_non_dengue_patients = Patient.accessible_by(current_ability).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).where("provisional_diagnosis = ?",0).group("provisional_diagnosis").count

  	months = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0]

  	@suspected = []
  	@confirmed = []
  	@probable = []

  	data_bar_chart = Patient.accessible_by(current_ability).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).where("provisional_diagnosis IN (?)",[1,2,3]).group("provisional_diagnosis","EXTRACT(month FROM created_at)").count

  	months.each do |month|
  		@probable << (data_bar_chart[["Probable",month]] || 0)
  		@suspected << (data_bar_chart[["Suspected",month]] || 0)
  		@confirmed << (data_bar_chart[["Confirmed",month]] || 0)
  	end

  	@outcome = Patient.accessible_by(current_ability).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).group("patient_outcome").count
  	@referred = Patient.accessible_by(current_ability).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).count

  end

  def home_lab_users
    params[:d_from] = 1.week.ago.to_date  unless params[:d_from].present?
    params[:d_to] = Time.now.to_date      unless params[:d_to].present?
    
    months = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0]

	  @confirmed = []
  	@probable = []

  	@ns_1 = []
  	@igg = []
  	@igm = []

  	data_bar_chart = LabPatient.accessible_by(current_ability).filter_by_d_from(params[:d_from]).filter_by_d_to(params[:d_to]).where("provisional_diagnosis IN (?) and lab_id = ?",[0,1],current_user.lab_id).group("provisional_diagnosis","EXTRACT(month FROM created_at)").count
  	ns_1_data = LabPatient.accessible_by(current_ability).filter_by_d_from(params[:d_from]).filter_by_d_to(params[:d_to]).group("ns_1","EXTRACT(month FROM created_at)").count
  	igg_data = LabPatient.accessible_by(current_ability).filter_by_d_from(params[:d_from]).filter_by_d_to(params[:d_to]).group("igg","EXTRACT(month FROM created_at)").count
  	igm_data = LabPatient.accessible_by(current_ability).filter_by_d_from(params[:d_from]).filter_by_d_to(params[:d_to]).group("igm","EXTRACT(month FROM created_at)").count

  	months.each do |month|
  		@probable << (data_bar_chart[["Probable",month]] || 0)
  		@confirmed << (data_bar_chart[["Confirmed",month]] || 0)
  		@ns_1 << (ns_1_data[["Positive",month]] || 0)
  		@igg << (igg_data[["Positive",month]] || 0)
  		@igm << (igm_data[["Positive",month]] || 0)
  	end

  end

  def provincial_user_dashboard
    authorize! :provincial_user_dashboard, Patient
    params[:d_from] = 1.week.ago.to_date  unless params[:d_from].present?
    params[:d_to] = Time.now.to_date      unless params[:d_to].present?
    patient_outcome_array = [0, 2]  #admitted and discharged only
    patient_outcome_array2 = [1, 2]
    provisional_diagnosis_array = [1, 2, 3] #all but non dengue
    @date_array = []
    @admitted_data = []
    @discharged_data = []
    @confirmed_data = []
    @probable_data = []
    @suspected_data = []

    #Boxes Counts
    @confirmed_patient_count = Patient.where("provisional_diagnosis = 3 and patients.district_id != 12").filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("patient_outcome").count

    @confirmed_patient_count_24 = Patient.where("provisional_diagnosis = 3 and patients.district_id != 12 and patients.created_at > ?", 24.hours.ago).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("patient_outcome").count

    #Admitted vs Discharged Chart
    @patient_status_details = Patient.where("patient_outcome in (?) and patients.district_id != 12 and is_released is not true",patient_outcome_array).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("patient_outcome", "DATE(patients.created_at)").count
   
    #Prepare Data for charts
    keys = @patient_status_details.keys
    @date_array = keys.map {|row| row[1]}
    @date_array.uniq!
    @date_array.sort!

    @date_array.each do |k|
      @admitted_data << (@patient_status_details[[ "Admitted",k]] || 0)
      @discharged_data << (@patient_status_details[[ "Discharged",k]] || 0)
    end
    
    
    #Provisional Diagnosis Wise 
    @provisional_diagnosis_details = Patient.where("provisional_diagnosis IN (?) and patients.district_id != 12", provisional_diagnosis_array).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("provisional_diagnosis", "DATE(patients.created_at)").count

    keys = @provisional_diagnosis_details.keys
    @date_array1 = keys.map {|row| row[1]}
    @date_array1.uniq!
    @date_array1.sort!
    @date_array1.each do |d|
      @confirmed_data << (@provisional_diagnosis_details[["Confirmed", d]] || 0)
      @probable_data << (@provisional_diagnosis_details[["Probable", d]] || 0)
      @suspected_data << (@provisional_diagnosis_details[["Suspected", d]] || 0)
    end

    @date_array = @date_array.map(&:to_s).to_json.html_safe
    @date_array1 = @date_array1.map(&:to_s).to_json.html_safe

    @admitted_details = Patient.joins(:admitted_hospital).where("patient_outcome = 0 and is_released is not true and provisional_diagnosis != 0 and patients.district_id != 12").filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("provisional_diagnosis", "hospitals.category").count
    
    @admitted_suspected_total = (@admitted_details[["Suspected", "SHC&MED"]] || 0) + (@admitted_details[["Suspected", "P&SHD"]] || 0) + (@admitted_details[["Suspected", "Private"]] || 0)
    @admitted_confirmed_total = (@admitted_details[["Confirmed", "SHC&MED"]] || 0) + (@admitted_details[["Confirmed", "P&SHD"]] || 0) + (@admitted_details[["Confirmed", "Private"]] || 0)
    @admitted_probable_total = (@admitted_details[["Probable", "SHC&MED"]] || 0) + (@admitted_details[["Probable", "P&SHD"]] || 0) + (@admitted_details[["Probable", "Private"]] || 0)

    @death_recovery_details = Patient.joins(:admitted_hospital).where("patient_outcome IN (?) and provisional_diagnosis = 3 and patients.district_id != 12", patient_outcome_array2).filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("patient_outcome", "hospitals.category").count

    beds_details = Bed.joins(:hospital).where("hospitals.district_id != 12").filter_by_district_id(params[:district]).filter_by_hospital_id(params[:hospital_id]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_category(params[:category]).group("hospitals.category").select("hospitals.category, SUM(total_ward_beds) as total_ward_beds, SUM(occupied_ward_beds) as
    occupied_ward_beds, SUM(total_hdu_beds) as total_hdu_beds, SUM(occupied_hdu_beds) as occupied_hdu_beds")

    @beds_result = Hash.new  
    @beds_result["SHC&MED"] = 0
    @beds_result["P&SHD"] = 0
    @beds_result["Private"] = 0
    beds_details.each do |b|
      @beds_result[b.category] = [b.total_ward_beds, b.occupied_ward_beds, b.total_hdu_beds, b.occupied_hdu_beds]
    end
  end

  def district_wise_confirmed_cases
    params[:d_from] = 1.week.ago.to_date  unless params[:d_from].present?
    params[:d_to] = Time.now.to_date      unless params[:d_to].present?

    @confirmed_cases = Patient.where("provisional_diagnosis = 3 and patients.district_id != 12").filter_by_from(params[:d_from]).filter_by_to(params[:d_to]).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("district_id").count

    @confirmed_cases_24_hours = Patient.where("provisional_diagnosis = 3 and patients.district_id != 12 and created_at > ?", 24.hours.ago).filter_by_district_id(params[:district]).filter_by_facility_type(params[:facility_type]).filter_by_hospital_id(params[:hospital_id]).filter_by_hospital_category(params[:category]).group("district_id").count

    @districts = District.where("province_id = 1").select("id", "district_name").pluck(["id", "district_name"]).uniq.sort
  end

  def district_wise_hotspot_coverage
    authorize! :district_wise_hotspot_coverage, SimpleActivity
    @total_hotspots = Hotspot.accessible_by(current_ability).where("is_active is true").group("district_id").count
    @visited_hotspots = SimpleActivity.accessible_by(current_ability).where("tag_category_name = ? and hotspot_id is not null and created_at >= ?", "Hotspots", 1.week.ago).group("district_id").count("distinct hotspot_id")
    @districts = District.accessible_by(current_ability).where("province_id = 1").select("id", "district_name").pluck(["id", "district_name"]).uniq.sort
  end

  def hospital_compliance_report
    unless params[:d_from].present?
      params[:d_from] = 24.hours.ago
    end

    unless params[:d_to].present?
      params[:d_to] = Time.now
    end

   query_str = "select category, count(distinct hospitals.id) as total_units, count(distinct c.hospital_id) as compliant_units from hospitals left outer join (select distinct hospital_id from patients where created_at > '#{params[:d_from]}' and created_at < '#{params[:d_to]}' UNION select distinct hospital_id from zero_patients where created_at > '#{params[:d_from]}' and created_at < '#{params[:d_to]}' ) c on c.hospital_id = hospitals.id group by category"

   @result = Hospital.find_by_sql(query_str)
  end

  def dept_wise_compliance_report
    @per_page  = 20


    if params[:d_from].present? and params[:d_to].present?
      params[:d_from] = Time.parse("#{params[:d_from]}").to_datetime.beginning_of_day rescue 24.hours.ago
      params[:d_to] = Time.parse("#{params[:d_to]}").to_datetime.end_of_day rescue Time.now
      date_filters = "created_at > '#{params[:d_from]}' and created_at < '#{params[:d_to]}'"
    else
      date_filters = true
    end
    # unless params[:d_from].present?
    #   params[:d_from] = 24.hours.ago
    # end

    # unless params[:d_to].present?
    #   params[:d_to] = Time.now
    # end

    query_str = "select category, facility_type, hospital_name from hospitals left outer join (select distinct hospital_id from patients where #{date_filters} UNION select distinct hospital_id from zero_patients where #{date_filters}) c on c.hospital_id = hospitals.id where c.hospital_id is null and hospitals.category = '#{params[:category]}'"
    
    respond_to do |format|
      format.html{
        @per_page  = 20
        @result = Hospital.paginate_by_sql(query_str, :page => params[:page], :per_page => @per_page)
      }
      format.xls {
        @result = Hospital.find_by_sql(query_str)
      }
    end
  end

end
