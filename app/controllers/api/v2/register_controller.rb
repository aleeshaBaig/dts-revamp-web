class Api::V2::RegisterController < Api::GpApplicationController
    skip_before_action :authenticate_request, except: %i[change_password]
    before_action :is_valid_mobile_api_key
    
    def sign_up
        data = JSON.parse(params["gp_dengue_user"])
        gp_dengue_user = GpDengueUser.new(data)
        
        if gp_dengue_user.save
            gp_deng_user = JSON.parse(gp_dengue_user.to_json)
            gp_deng_user["access_token"] = JsonWebToken.encode(user_id: gp_dengue_user.id)
            render json: {
                "message": "Sign up successfully",
                "code": 200,
                "status": true,
                "data": gp_deng_user
            }
        else
             render json: {message: "#{gp_dengue_user.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}
        end
    end
    def change_password

      old_password = params[:old_password]
      new_password = params[:new_password]
      is_logged_in = true
      puts current_api_user.as_json
      if current_api_user.authenticate(old_password)
        if current_api_user.update_attributes(password: new_password, password_confirmation: new_password, is_logged_in: false)
          render json: {code: 200, message: 'password has been updated!', status: true, is_logged_in: false}
        else
          render json: {error: 1, code: 0, message: current_api_user.errors.full_messages.to_sentence, is_logged_in: true}
        end
      else
        render json: {error: 1, code: 0, message: "Old Password did not match", status: true, is_logged_in: true}
      end
    end
end