class Api::V3::LabsController < Api::LabApplicationController
    before_action :is_valid_lab_api_key
    include PatientsHelper
    def create_patient

        provisional_diagnosis = params[:patient][:provisional_diagnosis]
        p_name = params[:patient][:patient_name]
        p_contact = params[:patient][:patient_contact]
        
        ## if Confirmed 
        if provisional_diagnosis == 'Confirmed'

            ## Make Cell No & Name as Unique
            patient_obj = Patient.is_unique_identification_from_lab?(p_name, p_contact)
            
            ## if Lab Patient Already Exist
            if patient_obj.present?
                patient = patient_obj.last
                if patient.valid_api_from_lab?
                    # puts "======================= update"
                    patient.updated_id = current_api_user.id
                    patient.comments = "Updated By #{current_api_user.username} #{Time.now}"
                    
                    if patient.update(patient_params)
                        render json: {message: "Patient update successfully.", code: 200, status: true}
                    else
                        render json: {message: "#{patient.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}
                    end
                else
                    render json: {message: "Patient outcome should not be Admitted or OutPatient", code: 0, error: 'failed', status: true}
                end
            else
                # puts "======================= Create"
                    patient = Patient.new(patient_params)
                    patient.updated_id = current_api_user.id
                    patient.lab_user_id = current_api_user.id
                    patient.lab_user_name = current_api_user.username
                    patient.hospital_id = current_api_user.lab_id
                    patient.lab_name = current_api_user.lab.try(:hospital_name)
                    patient.lab_id = current_api_user.lab.try(:id)
                    patient.patient_status = "Lab"
                    patient.entered_by = "By Lab"
                    patient.comments = "Entered By #{current_api_user.username} #{Time.now}"
                if patient.save
                    render json: {message: "Patient create successfully.", code: 200, status: true}
                else
                    render json: {message: "#{patient.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}
                end
            end
            
        else
            render json: {message: "Provisional Diagnosis should be 'Confirmed'", code: 0, error: 'failed', status: true}
        end
    end

    private
    def patient_params
        params.require(:patient).permit(:p_search_type, :passport, :death_date, :discharge_date, :admission_date, :lama_date, :comments, :confirmation_date, :lab_patient_id, :patient_name, :fh_name, :age, :age_month, :gender, :cnic, :cnic_relation, :patient_contact, :relation_contact, :address, :district, :district_id, :tehsil, :tehsil_id, :uc, :uc_id, :permanent_address, :permanent_district, :permanent_district_id, :permanent_tehsil, :permanent_tehsil_id, :permanent_uc, :permanent_uc_id, :workplace_address, :workplace_district, :workplace_district_id, :workplace_tehsil, :workplace_tehsil_id, :workplace_uc, :workplace_uc_id, :date_of_onset, :fever_last_till, :fever, :previous_dengue_fever, :associated_symptom, :provisional_diagnosis, :other_diagnosed_fever, :patient_status, :patient_outcome, :patient_condition, :hospital, :hospital_id, :user_id, :username, :reporting_date, :referred_to_id,:is_released, :lab_result_attributes => [:hct_first_reading,:hct_first_reading_date, :wbc_first_reading, :wbc_first_reading_date, :platelet_first_reading, :platelet_first_reading_date, :ns1, :pcr, :igm, :igg, :warning_signs,:diagnosis, :dengue_virus_type, :report_ordering_date, :report_receiving_date, {:advised_test => []} ,:id])
    end
end