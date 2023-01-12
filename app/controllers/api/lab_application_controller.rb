module Api
    class LabApplicationController < ActionController::API
        before_action :lab_authenticate_request
        
        ## attributes accessor
        attr_reader :current_api_user
        
        private
        
        ## Authenticate Request
        def lab_authenticate_request
            @current_api_user = AuthorizeLabApiRequest.call(request.headers).result
            render json: {  message: "This is not a authorized request.", error: 'failed', code: 0 } unless @current_api_user
        end
        
        ## Valid Api Key
        def is_valid_lab_api_key
            lab_key = request.headers["LabKey"]
            render json: {message: "Secret Key do not matched!", code: 0, error: 'failed', status: true}  unless LAB_HAS_KEY.include?(lab_key)
        end
    end
end