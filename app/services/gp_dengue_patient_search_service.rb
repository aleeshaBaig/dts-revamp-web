class GpDenguePatientSearchService

	def initialize(current_ability)
        @current_ability = current_ability
	end

	def run params=nil
        if params.nil?
            gp_dengue_patients = gp_dengue_patients_obj
        else
            #### filters ################
            gp_dengue_patients = gp_dengue_patients_obj.where(nil)
            filtering_params(params).each do |key, value|
                gp_dengue_patients = gp_dengue_patients.public_send(key, value) if value.present?
            end
        end

        gp_dengue_patients
	end

    def gp_dengue_patients_obj
        GpDenguePatient.accessible_by(@current_ability).includes(:current_address, :gp_dengue_user).joins(:current_address, :gp_dengue_user)
    end

    def filtering_params(params)
        params.slice(:patient_id, :patient_name, :gender, :cnic, :contact_no, :provisional_diagnosis, :datefrom, :dateto, :district_id, :tehsil_id, :uc_id, :hospital_id, :entered_by, :province_id)
    end
end
