class Api::V3::AuthenticationController < Api::LabApplicationController
  
  ## Filters
  skip_before_action :lab_authenticate_request
  before_action :is_valid_lab_api_key
  
  ## Login
  def login
    lab_key = request.headers["LabKey"]
    command = AuthenticateLabUser.call(params[:username], params[:password], lab_key)
    
    if command.success?
        render json: {
              "message": "logged in successfully.",
              "code": 200,
              "status": true,
              "data": command.result
        }
    else
      render json: {error: "#{command.errors.full_messages.to_sentence}", code: 0, message: 'failed', status: false}, status: :unauthorized
    end
  end
  def lab_sync_data
    render json:
      {
          "code": 200,
          "status": true,
          "message": "Data is synced successfully",
          "error": "null",
          "data": {
              provisional_diagnosis: Patient::provisional_diagnoses.keys,
              gender: ["Male", "Female", "Other"],
              ns1: ["Positive", "Negative", "Not Prescribed", "Awaited"],
              igm: ["Positive", "Negative", "Not Prescribed", "Awaited"],
              igg: ["Positive", "Negative", "Not Prescribed", "Awaited"],
              province_list: Province.select(:id, :province_name).order("province_name asc").as_json,
              district_list: District.select(:id, :district_name, :province_id).order("district_name asc").as_json,
              tehsil_list: Tehsil.select(:id, :tehsil_name, :district_id).order("tehsil_name asc").as_json
          }
      }
  end

  ## Sign Out
  # def signout
  #   @current_api_user = JsonWebToken.decode(request.headers['Authorization'])
  #   render json: {code: 200, message: 'successfully signout', status: true}    
  # end
  
end