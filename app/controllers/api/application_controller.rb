module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_request
    attr_reader :current_api_user
    
    private
    
    def authenticate_request
      @current_api_user = AuthorizeApiRequest.call(request.headers).result
      
      render json: {  error: "This is not a authorized request.", message: 'failed', code: 0 }, 
                      status: :unauthorized unless @current_api_user
    end
    
    def is_valid_mobile_api_key
      mobile_key = request.headers["MobileKey"]
      unless MOBILE_HAS_KEY.include?(mobile_key)
          render json: {error: "Mobile Secret Key do not matched!", code: 0, message: 'failed', status: true}, status: :unauthorized
      end
    end
  end
end