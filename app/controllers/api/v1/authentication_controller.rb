class Api::V1::AuthenticationController < Api::ApplicationController
  
  skip_before_action :authenticate_request
  
  def authenticate
    mobile_key = request.headers["MobileKey"]
    command = AuthenticateUser.call(params[:username], params[:password], mobile_key)
    if command.success?
      if tpv_json?
        render json: tpv_data(command)
      else
        render json: {user: antidengue_data(command), token: command.result, code: 200, message: 'success', status: true}
      end
    else
      render json: {error: "#{command.errors.full_messages.to_sentence}", code: 0, message: 'failed', status: false}, status: :unauthorized
    end
  end
  def signout
    @current_api_user = JsonWebToken.decode(request.headers['Authorization'])
    render json: {code: 200, message: 'successfully signout', status: true}    
  end

  def mobile_user
    MobileUser.includes(:tehsils, :department).find_by(username: params[:username].try(:downcase))
  end
  def antidengue_data(command)
		api_user = mobile_user
		user_resp = Hash.new
		u_towns = []
		# user_resp = @user
		user_resp["user_id"] = api_user.id
		user_resp["username"] = api_user.username
		user_resp["role"] = api_user.role
    user_resp["is_forgot"] = api_user.is_forgot
    user_resp["is_surveillance"] = api_user.is_surveillance
		api_user.tehsils.each do |tehsil|
      u_towns << { "town_id": tehsil.id, "town": tehsil.tehsil_name}
    end
		user_resp["towns"] =  u_towns
		user_resp["district_id"] = api_user.district_id
		user_resp["district"] = api_user.district
		user_resp["uc_id"] = Uc.first.id
		user_resp["uc"] = Uc.first.uc_name
		user_resp["department_id"] = api_user.department_id
		user_resp["department"] = api_user.department.try(:department_name)
		return user_resp      
  end
  def tpv_data(command)
    api_user = mobile_user
    data =
          {
            "message": "logged in succesfully",
            "code": 200,
            "status": true,
            "data": {
                "department": "#{api_user.department.try(:department_name)}",
                "district": "#{api_user.district.try(:district_name)}",
                "email": "xyz@xyz.com",
                "full_name": "#{api_user.username}",
                "hospital": "",
                "is_active": true,
                "location": "#{api_user.district.try(:district_name)}",
                "mobilesource": "Department own Mobile",
                "town": "#{api_user.tehsils.try(:first).try(:tehsil_name)}",
                "uc": Uc.first.uc_name,
                "username": "#{api_user.username}",
                "password": "#{params[:password]}",
                "user_id": "#{api_user.id}",
                "access_token": "#{command.result}"
            }
        }
    return data
  end  

  def tpv_json?
    mobile_user.role == 'TPV'
  end
end