class Api::V2::AuthenticationController < Api::GpApplicationController
  
    skip_before_action :authenticate_request
    before_action :is_valid_mobile_api_key

    def login
      command = AuthenticateGpUser.call(params[:email], params[:password], request.headers["MobileKey"])
      if command.success?
        render json: gp_response(command)
      else
        render json: {message: "#{command.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}
      end
    end
    
    def signout
      @current_api_user = JsonWebToken.decode(request.headers['Authorization'])
      render json: {code: 200, message: 'logged out successfully.', status: true}    
    end
    def gp_sync
      
      render json:
      {
        "code": 200,
        "status": true,
        "message": "Data is synced successfully",
        "error": "null",
        "data": {
          provisional_diagnosis: GpDenguePatient::provisional_diagnoses.keys,
          symptoms_name: GpSymptom::associate_symptoms.keys,
          dengue_fever_type: GpLabDiagnostice::dengue_fever_types.keys,
          warning_signs: GpLabResult::warning_signs.keys,
          reffer_types: GpDenguePatient::reffer_types.keys,
          gender: GpDenguePatient::genders.keys,
          ns1: GpLabDiagnostice::ns1s.keys,
          pcr: GpLabDiagnostice::pcrs.keys,
          igm: GpLabDiagnostice::igms.keys,
          igg: GpLabDiagnostice::iggs.keys,
          user_role: GpDengueUser::roles.keys,
          hospital_list: Hospital.order("hospital_name asc").as_json,
          province_list: Province.order("province_name asc").as_json,
          district_list: District.order("district_name asc").as_json,
          tehsil_list: Tehsil.order("tehsil_name asc").as_json,
          uc_list: Uc.order("uc_name asc").as_json,
        }
      }
    end
    def gp_response(command)
      # response = JSON.parse(command.result.to_json)
      # response["gp_dengue_patient"]["access_token"] = response["access_token"]
      # response["gp_dengue_patient"]["access_token"]
      data =
            {
              "message": "logged in successfully.",
              "code": 200,
              "status": true,
              "data": command.result
          }
      return data
    end  

  end