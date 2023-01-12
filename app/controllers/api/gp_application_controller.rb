module Api
    class GpApplicationController < ActionController::API
    before_action :authenticate_request
    attr_reader :current_api_user
    
    private
    
    def authenticate_request
    @current_api_user = GpAuthorizeApiRequest.call(request.headers).result
    render json: {  message: "This is not a authorized request.", error: 'failed', code: 0 } unless @current_api_user
    end
    def is_valid_mobile_api_key
    mobile_key = request.headers["MobileKey"]
    unless MOBILE_HAS_KEY.include?(mobile_key)
        render json: {message: "Mobile Secret Key do not matched!", code: 0, error: 'failed', status: true}
    end
    end
end
end