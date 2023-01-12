class AuthenticateGpUser
    prepend SimpleCommand
    
    def initialize(email, password, mobile_key)
      @email = email
      @password = password
      @mobile_key = mobile_key
      
    end
    
    def call
      if api_user
        access_token = JsonWebToken.encode(user_id: api_user.id)
        user_response = api_user.as_json
        user_response["access_token"] = access_token
        return user_response
      end
    end
    
    private
    
    attr_accessor :email, :password, :mobile_key
    
    def api_user
      user = GpDengueUser.find_by(email: email)
      unless user.present?
        # errors.add :base, "Invalid Email"
        errors.add :base, "Invalid credentials"
        return nil
      end
      
      # Verify the password. You can create a blank method for now.
      unless user.authenticate(password)
        # errors.add :base, "Invalid Password"
        errors.add :base, "Invalid credentials"
        return nil
      end
      
      unless MOBILE_HAS_KEY.include?(mobile_key)
        errors.add :base, "Mobile Secret Key do not matched!"
        return nil
      end
      
      return user
    end
    
  end
