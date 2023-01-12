class AuthenticateLabUser
    prepend SimpleCommand
    
    def initialize(username, password, lab_key)
      @username = username.try(:downcase)
      @password = password
      @lab_key = lab_key
    end
    
    def call
      JsonWebToken.encode(user_id: api_user.id) if api_user
    end
    
    private
    
    attr_accessor :username, :password, :lab_key
    
    def api_user
      user = User.lab_user.find_by(username: username)
      unless user.present?
        errors.add :base, "Invalid Username"
        return nil
      end
      
      # Verify the password. You can create a blank method for now.
      unless user.valid_password?(password)
        errors.add :base, "Invalid Password"
        return nil
      end
      
      unless LAB_HAS_KEY.include?(lab_key)
        errors.add :base, "Secret Key do not matched!"
        return nil
      end
      
      return user
    end
    
  end