class AuthenticateUser
  prepend SimpleCommand
  
  def initialize(username, password, mobile_key)
    @username = username.try(:downcase)
    @password = password
    @mobile_key = mobile_key
  end
  
  def call
    JsonWebToken.encode(user_id: api_user.id) if api_user
  end
  
  private
  
  attr_accessor :username, :password, :mobile_key
  
  def api_user
    user = MobileUser.is_active.find_by(username: username)
    unless user.present?
      errors.add :base, "Invalid Username"
      return nil
    end
    
    # Verify the password. You can create a blank method for now.
    unless user.authenticate(password)
      errors.add :base, "Invalid Password"
      return nil
    end
    
    unless MOBILE_HAS_KEY.include?(mobile_key)
      errors.add :base, "Mobile Secret Key do not matched!"
      return nil
    end
    
    return user
  end
  
end