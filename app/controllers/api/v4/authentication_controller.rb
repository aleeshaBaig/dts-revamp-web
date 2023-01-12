class Api::V4::AuthenticationController < Api::ApplicationController
  
  skip_before_action :authenticate_request
  
  def authenticate
    mobile_key = request.headers["MobileKey"]
    command = AuthenticateUser.call(params[:username], params[:password], mobile_key)
    if command.success?
      render json: {user: situation_app_data(command), token: command.result, code: 200, message: 'success', status: true}
    else
      render json: {error: "#{command.errors.full_messages.to_sentence}", code: 0, message: 'failed', status: false}, status: :unauthorized
    end
  end

  def signout
    @current_api_user = JsonWebToken.decode(request.headers['Authorization'])
    render json: {code: 200, message: 'successfully signout', status: true}    
  end

  def mobile_user
    MobileUser.is_active.includes(division: :districts).find_by(username: params[:username].try(:downcase))
  end
  
  def situation_app_data(command)
		api_user = mobile_user
    puts "==========#{api_user.role}"
    if api_user.is_divisional_user?
      user_division = api_user.division
      user_districts = user_division.present? ? user_division.districts.select("id as district_id, district_name").as_json(except: [:id]) : []
    else
      user_districts = [{"district_name": api_user.district,"district_id": api_user.district_id}]
    end
    
		
    user_resp = Hash.new
		u_towns = []
		# user_resp = @user
		user_resp["user_id"] = api_user.id
		user_resp["username"] = api_user.username
		user_resp["role"] = api_user.role
    user_resp["is_forgot"] = api_user.is_forgot
		user_resp["user_district_id"] = api_user.district_id
		user_resp["user_district_name"] = api_user.district
    user_resp["districts"] = user_districts
		return user_resp      
  end
  
end