class AuthorizeLabApiRequest
    prepend SimpleCommand
    
    def initialize(headers = {})
      @headers = headers
    end
    
    def call
      api_user
    end
    
    private
    
    attr_reader :headers
    
    def api_user
      @api_user ||= User.lab_user.find(decoded_auth_token[:user_id]) if (decoded_auth_token and LAB_HAS_KEY.include?(headers['LabKey']) )
      @api_user || errors.add(:token, "Invalid token") && nil
    end
    
    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
    end
    
    def http_auth_header
      if headers['Authorization'].present?
        return headers['Authorization'].split(' ').last
      else
        errors.add(:token, "Missing token")
      end
      nil
    end
  end