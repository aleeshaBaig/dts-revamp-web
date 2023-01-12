class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :destroy]
  # before_action :set_edit_patient, only: [:edit, :update]
  before_action :authenticate_user!
  load_and_authorize_resource
  include PatientsHelper
  include ApplicationHelper
  layout 'adminpanel'

  ## Lab Test History
  def diagnosis_change_log
    
    q_patient_id = params[:patient_id].present? ? "auditable_id = #{params[:patient_id]}" : true
    q_district = params[:district].present? ? "hos.district_id = #{params[:district]}" : true
    q_facility_type = params[:facility_type].present? ? "hos.facility_type = '#{params[:facility_type]}'" : true
    q_hospital = params[:hospital].present? ? "p.hospital_id = #{params[:hospital]}" : true

    where_clause = "#{q_patient_id} and #{q_district} and #{q_facility_type} and #{q_hospital}"

    q = "#{patient_lab_tests_summary(where_clause)}"
    respond_to do |format|
      format.html { @patients = Patient.paginate_by_sql(q, :page => params[:page], :per_page => 20)}
      format.csv{
        send_data Patient.diagnosis_change_log_csv(current_user, q), filename: "diagnosis_change_log-#{Date.today}.csv", layout: false, type: 'text/csv;chartset=utf-8'
      }
    end
  end

  ## Lab Patient Search CNIC/Passport
  def search_patient
    authorize! :search_patient, Patient
    if params[:cnic].present? || params[:passport].present? || params[:p_id].present? || params[:patient_contact].present?
      @patients = Patient.accessible_by(current_ability, :search_patient).filters(params).ascending.paginate(:page => params[:page], :per_page => 20)
    else
      @patients = []
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end
  
  def index
    per_page = per_page_items(1000000)
    @is_hospital_user = current_user.hospital_user? ? true : false
    @is_hospital_district_enable = current_user.phc_user? ? true : false
    @current_user_is_admin = current_user.admin? ? true : false

    if params.has_key? :cnic
      
      if current_user.phc_user?
        @patients = Patient.phc_patients_joins
      else
        @patients = Patient.includes(:lab_patient, :lab_result, :from_lab, :user, :updated_by)
      end
      @patients = @patients.accessible_by(current_ability).filters(params).ascending
    else
      @patients = []
    end

    respond_to do |format|
      if params.has_key? :cnic
        format.html{@patients = @patients.paginate(:page => params[:page], :per_page => per_page)}
      else
        format.html
      end
      format.csv { send_data (@patients.present? ? @patients.to_csv(current_user) : Patient.to_csv(current_user, false)), filename: "patient-line-listing-#{Date.today}.csv", layout: false, type: 'text/csv;chartset=utf-8'}
      
      # format.xls{
      #   response.headers['Content-Disposition'] = "attachment; filename=patient-line-listing-#{Date.today}.xls"
      #   render partial: 'patients/downloads/index', layout: false
      # }
      # format.xlsx{
      #   response.headers['Content-Disposition'] = "attachment; filename=patient-line-listing-#{Date.today}.xlsx"
      #   render partial: 'patients/downloads/index', layout: false
      # }
    end
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient = Patient.new
    @patient.build_lab_result
    if params[:lab_patient_id].present?
      lab_patient = LabPatient.find(params[:lab_patient_id])
      @patient.load_lab_patient(lab_patient)
    end    
  end

  # GET /patients/1/edit
  def edit
    unless @patient.lab_result.present?
      @patient.build_lab_result
    end
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)
    @patient.updated_id = current_user.id
  
    if current_user.lab_user?
      @patient.lab_user_id = current_user.id
      @patient.lab_user_name = current_user.username
      @patient.hospital_id = current_user.lab_id
      @patient.lab_name = current_user.lab.try(:hospital_name)
      @patient.lab_id = current_user.lab.try(:id)
      @patient.patient_status = "Lab"
      @patient.entered_by = "By Lab"
    else
      @patient.user_id = current_user.id
      @patient.username = current_user.username
    end
    
    
    
    # if @patient.lab_patient_id.present?
    #   @patient = assign_transfer_type(@patient)
    # end

    
    respond_to do |format|
      if @patient.save
        format.html { redirect_to patients_url, notice: 'Patient was successfully created.' }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
    ## assigned lab patient transfer type
    # if @patient.lab_patient_id.present?
    #   # lab_patient = LabPatient.find(@patient.lab_patient_id)
    #   # lab_patient = assign_transfer_type(lab_patient)
    #   if lab_patient.save(validate: false)
    #     if current_user.dpc_user?
    #       format.html { redirect_to lab_patients_url, notice: 'Patient is transferred successfully.' }
    #     else
    #       format.html { redirect_to patients_url, notice: 'Patient was successfully created.' }
    #     end
    #   end
    # else
    # format.html { redirect_to patients_url, notice: 'Patient was successfully created.' }
    # end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    @patient.updated_id = current_user.id unless current_user.dpc_user?
    # unless current_user.lab_user?
    #   unless @patient.user_id.present?
    #       # @patient.user_id = current_user.id
    #       # @patient.username = current_user.username
    #       @patient.transfer_type = 'Lab To Hospital' ## transfer lab to hospital
    #   end
    # end

    respond_to do |format|
      if @patient.update(patient_params)
        # format.html { redirect_to edit_patient_url(@patient.id), notice: 'Patient was successfully updated.' }
        format.html { redirect_to patients_url, notice: 'Patient was successfully updated.' }
        format.json { render :show, status: :ok, location: @patient }
      else
        puts "=======#{@patient.errors.full_messages}"
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  def refer_patients
    q_cnic = params[:cnic].present? ? "patients.cnic = '#{params[:cnic]}'" : 'true'
    @patient = Patient.where("#{q_cnic}").last
  end
  
  def release_patient
    patient = Patient.find(params[:patient_id])
    if patient.is_released == false or patient.is_released == nil 
      patient.update_attributes(:is_released => true, :patient_status => "Closed", :patient_outcome => "Discharged")
    end

    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient is released successfully.' }
    end
  end

  def released_patients  
    if params[:pagination] == "No" 
      per_page = 1000000
    else 
      per_page = 10 
    end 
    
    @patients = Patient.accessible_by(current_ability, :read).where("is_released is true").filters(params).paginate(:page => params[:page], :per_page =>
    per_page).order("updated_at DESC")
    
    respond_to do |format|
      format.html 
      format.xls
    end
  end

  def transfer_patient
    patient = Patient.find(params[:patient_id])
    patient.update(:hospital_id => current_user.hospital_id, :is_released => false)

    respond_to do |format|
        format.html { redirect_to released_patients_url, notice: 'Patient is transferred successfully.' }
    end
  end
    
  def patient_test_history
    if params[:patient_id].present?
      @test_logs = TestLog.where(patient_id: params[:patient_id]).paginate(:page => params[:page], :per_page =>100).order("updated_at DESC")
    else
      @test_logs = []
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.updated_id = current_user.id
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  #### mark as zero patient ######
  def mark_as_zero_patient
    zero_patient = ZeroPatient.where("created_at >?",Time.now.to_datetime.beginning_of_day).where(user_id: current_user.id, t_type: :patient).count
    puts "======#{zero_patient}"
    if zero_patient == 0
      zero_patient = ZeroPatient.new(user_id: current_user.id, hospital_id: current_user.hospital_id, district_id: current_user.district_id, t_type: :patient)
      if zero_patient.save
        render json: {message: "Successfully updated!", error: 0}
      else
        render json: {message: "#{zero_patient.errors.full_messages}", error: 1}
      end
    else
      render json: {message: "Already marked zero patient for the day", error: 1}
    end
  end

  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    def set_edit_patient
      @patient = Patient.find(params[:id])
      if @patient.patient_outcome == "Death"
        @patient = []
      end
    end

    # Only allow a list of trusted parameters through.
    def patient_params
      params.require(:patient).permit(:p_search_type, :passport, :death_date, :discharge_date, :admission_date, :lama_date, :comments, :confirmation_date, :lab_patient_id, :patient_name, :fh_name, :age, :age_month, :gender, :cnic, :cnic_relation, :patient_contact, :relation_contact, :address, :district, :district_id, :tehsil, :tehsil_id, :uc, :uc_id, :permanent_address, :permanent_district, :permanent_district_id, :permanent_tehsil, :permanent_tehsil_id, :permanent_uc, :permanent_uc_id, :workplace_address, :workplace_district, :workplace_district_id, :workplace_tehsil, :workplace_tehsil_id, :workplace_uc, :workplace_uc_id, :date_of_onset, :fever_last_till, :fever, :previous_dengue_fever, :associated_symptom, :provisional_diagnosis, :other_diagnosed_fever, :patient_status, :patient_outcome, :patient_condition, :hospital, :hospital_id, :user_id, :username, :reporting_date, :referred_to_id,:is_released, :lab_result_attributes => [:hct_first_reading,:hct_first_reading_date, :wbc_first_reading, :wbc_first_reading_date, :platelet_first_reading, :platelet_first_reading_date, :hct_second_reading, :hct_second_reading_date, :wbc_second_reading, :wbc_second_reading_date, :platelet_second_reading, :platelet_second_reading_date, :hct_third_reading, :hct_third_reading_date, :wbc_third_reading, :wbc_third_reading_date, :platelet_third_reading, :platelet_third_reading_date, :ns1, :pcr, :igm, :igg, :warning_signs,:diagnosis, :dengue_virus_type, :report_ordering_date, :report_receiving_date, :cbc_report_order_date_first, :cbc_report_order_date_second, :cbc_report_order_date_third, :cbc_report_receiving_date_first, :cbc_report_receiving_date_second, :cbc_report_receiving_date_third, {:advised_test => []} ,:id])
    end

    def assign_transfer_type(patient)
      if current_user.dpc_user?
        patient.transfer_type = 'DPC'
        patient.is_dpc = true
      else
        patient.transfer_type = 'Lab To Hospital'
      end
      return patient
    end
end
