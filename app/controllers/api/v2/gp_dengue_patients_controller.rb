class Api::V2::GpDenguePatientsController < Api::GpApplicationController
    before_action :is_valid_mobile_api_key
    
    def create
        begin
            patient_demographic = JSON.parse(params["patient_demographic"])
            patient_current_address = JSON.parse(params["patient_current_address"])
            is_cnic_found = JSON.parse(params["is_found"])
            patient_id = JSON.parse(params["patient_id"])
            # patient_permanent_address = JSON.parse(params["patient_permanent_address"])
            # patient_workplace_address = JSON.parse(params["patient_workplace_address"])
            # gp_symptom = JSON.parse(params["gp_symptom"])
            # gp_lab_diagnostices = JSON.parse(params["gp_lab_diagnostices"])
            # gp_lab_results = JSON.parse(params["gp_lab_results"])
            
            ActiveRecord::Base.transaction do
                
                ## if CNIC FOUND CHANGE UPDATE
                
                if is_cnic_found == false
                    

                    ### NEW PATIENT
                    gp_dengue_patient = GpDenguePatient.new(patient_demographic)


                    ## CREATE NEW PATIENT >>>>>
                    if gp_dengue_patient.save
                        ### <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Addresses >>>>>>>>>>>>>>>>>>>>>>>>> ###
                        ## Current Addresses
                        current_address = gp_dengue_patient.build_current_address(patient_current_address)
                        current_address.save
                        
                        ## Permanent Addresses
                        # permanent_address = gp_dengue_patient.build_permanent_address(patient_permanent_address)
                        # permanent_address.save
                        ## Workplace Addresses
                        # workplace_address = gp_dengue_patient.build_workplace_address(patient_workplace_address)
                        # workplace_address.save
                        
                        ## GP Symtoms
                        # gp_symptom = gp_dengue_patient.build_gp_symptom(gp_symptom)
                        # gp_symptom.save

                        ## GP Lab Diagnostices
                        # gp_lab_diagnostice = gp_dengue_patient.build_gp_lab_diagnostice(gp_lab_diagnostices)
                        # gp_lab_diagnostice.save

                        ## GP Lab Result
                        # gp_lab_result = gp_dengue_patient.build_gp_lab_result(gp_lab_results)
                        # gp_lab_result.save
                        
                        
                        ## Picture Save
                        gp_deng_picture = gp_dengue_patient.save_picture(params["before_picture"])
                        if gp_deng_picture
                            gp_dengue_patient.before_picture = gp_deng_picture.before_picture.url
                            gp_dengue_patient.save
                        end
                        render json: {"message": "Patient is created successfully.", "code": 200, "status": true}
                    else
                        render json: {message: "#{gp_dengue_patient.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}, status: :unauthorized
                    end
                else
                    gp_dengue_patient = GpDenguePatient.find(patient_id)
                    if gp_dengue_patient.present?
                        if gp_dengue_patient.update(patient_demographic)
                            gp_dengue_patient.current_address.update(patient_current_address)

                            ## if picture not same
                            if params["before_picture"].present?
                                gp_dengue_patient.picture.delete if gp_dengue_patient.before_picture.present?
                                

                                ##CREATE NEW PICTURE
                                gp_deng_picture = gp_dengue_patient.save_picture(params["before_picture"])
                                gp_dengue_patient.before_picture = gp_deng_picture.before_picture.url
                                gp_dengue_patient.save
                            end
                            render json: {"message": "Patient Info is updated successfully.", "code": 200, "status": true}
                        else
                            render json: {message: "#{gp_dengue_patient.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}, status: :unauthorized
                        end
                    else
                        render json: {"message": "Patient not found", "code": 200, "status": true}
                    end
                end
            end
        rescue Exception => error
            render json: {message: "#{error.inspect}", code: 0, error: 'failed', status: true}, status: :unauthorized
        end
    end


    ## Search CNIC
    def search_cnic
        begin
            gp_dengue_patient = GpDenguePatient.find_by_cnic(params[:cnic])
            if gp_dengue_patient.present?
                data = {
                        patient_demographic: gp_dengue_patient.as_json, 
                        patient_current_address: gp_dengue_patient.current_address.as_json
                    }
                render json: {"message": "Patient found successfully", data: data, "code": 200, "status": true, is_found: true}
            else
                render json: {"message": "Patient could not be found against this CNIC", "code": 0, "status": true, is_found: false}
            end
        rescue Exception => error
            render json: {message: "#{error.inspect}", code: 0, error: 'failed', status: true, is_found: false}, status: :unauthorized
        end
    end
end