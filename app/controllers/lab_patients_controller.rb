class LabPatientsController < ApplicationController
  before_action :set_lab_patient, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  layout 'adminpanel'
  # GET /lab_patients
  # GET /lab_patients.json
  def index
    if params[:pagination] == "No"
      per_page = 1000000
    else
      per_page = 20
    end

    @lab_patients = LabPatient.accessible_by(current_ability).filters(params).order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
    respond_to do |format|
      format.html
      format.xls
    end
  end

  # GET /lab_patients/1
  # GET /lab_patients/1.json
  def show
    authorize! :show, @lab_patient
  end

  # GET /lab_patients/new
  def new
    @lab_patient = LabPatient.new
    if params[:cnic].present?
      @patient = Patient.find_by_cnic(params[:cnic])
      # if @patient.present?
      #   @lab_patient.set_patient_attributes(@patient)
      # end
    end
  end

  # GET /lab_patients/1/edit
  def edit
  end

  # POST /lab_patients
  # POST /lab_patients.json
  def create
    @lab_patient = LabPatient.new(lab_patient_params)
    @lab_patient.lab_id = current_user.lab_id if current_user.is_lab_patient_users?
    authorize! :create, @lab_patient
    respond_to do |format|
      if @lab_patient.save
        format.html { redirect_to lab_patients_url, notice: 'Lab patient was successfully created.' }
        format.json { render :show, status: :created, location: @lab_patient }
      else
        puts "====#{@lab_patient.errors.full_messages}"
        # params[:cnic] = params[:cnic]
        format.html { render :new }
        format.json { render json: @lab_patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lab_patients/1
  # PATCH/PUT /lab_patients/1.json
  def update
    authorize! :update, @lab_patient
    respond_to do |format|
      if @lab_patient.update(lab_patient_params)
        format.html { redirect_to lab_patients_url, notice: 'Lab patient was successfully updated.' }
        format.json { render :show, status: :ok, location: @lab_patient }
      else
        # puts "====#{@lab_patient.errors.full_messages}"
        format.html { render :edit }
        format.json { render json: @lab_patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_patients/1
  # DELETE /lab_patients/1.json
  def destroy
    authorize! :destroy, @lab_patient
    @lab_patient.destroy
    respond_to do |format|
      format.html { redirect_to lab_patients_url, notice: 'Lab patient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #### mark as zero patient ######
  def mark_as_zero_patient
    zero_patient = ZeroPatient.new(user_id: current_user.id, hospital_id: current_user.hospital_id, district_id: current_user.district_id, t_type: :patient)
    if zero_patient.save
      render js: "updated"
    else
      render js: "not updated"
    end
  end

  def mark_lab_as_zero_patient
    zero_patient = ZeroPatient.where("created_at >?",Time.now.to_datetime.beginning_of_day).where(user_id: current_user.id, t_type: :lab_patient).count
    if zero_patient == 0
      zero_patient = ZeroPatient.new(user_id: current_user.id, hospital_id: current_user.lab_id, district_id: current_user.district_id, lab_id: current_user.lab_id, t_type: :lab_patient)
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
    def set_lab_patient
      @lab_patient = LabPatient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lab_patient_params
      params.require(:lab_patient).permit(:comments, :reporting_date, :p_name, :fh_name, :age, :month, :gender, :cnic, :cnic_type, :contact_no, :other_contact_no, :house_no,:street_no,:locality, :district_id, :tehsil_id, :uc_id, :perm_house_no,:perm_street_no,:perm_locality, :perm_district_id, :perm_tehsil_id, :perm_uc_id, :workplc_house_no,:workplc_street_no,:workplc_locality, :workplc_district_id, :workplc_tehsil_id, :workplc_uc_id,:occupation, :provisional_diagnosis, :lab_id, :address, :perm_address, :workplc_address, :district, :tehsil, :uc, :perm_district, :perm_tehsil, :perm_uc, :workplc_district, :workplc_tehsil, :workplc_uc, :hct_first_reading,:hct_first_reading_date, :wbc_first_reading, :wbc_first_reading_date, :platelet_first_reading, :platelet_first_reading_date, :hct_second_reading, :hct_second_reading_date, :wbc_second_reading, :wbc_second_reading_date, :platelet_second_reading, :platelet_second_reading_date, :hct_third_reading, :hct_third_reading_date, :wbc_third_reading, :wbc_third_reading_date, :platelet_third_reading, :platelet_third_reading_date, :ns_1, :pcr, :igm, :igg)
    end
end
