class Api::V2::GpFormsController < Api::GpApplicationController
    before_action :is_valid_mobile_api_key
    
    def create
        begin
            gp_form = JSON.parse(params["data"])

            ActiveRecord::Base.transaction do
                gp_form = GpForm.new(gp_form)
                if gp_form.save
                    ## Picture Save
                    gp_form_picture = gp_form.save_picture(params["before_picture"])
                    if gp_form_picture
                        gp_form.before_picture = gp_form_picture.before_picture.url
                        if gp_form.save
                            render json: {"message": "Form is created successfully.", "code": 200, "status": true}
                        else
                            render json: {message: "#{gp_form.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}  
                        end
                    end
                    
                else
                    render json: {message: "#{gp_form.errors.full_messages.to_sentence}", code: 0, error: 'failed', status: true}
                end
            end
        rescue Exception => error
            render json: {message: "#{error.inspect}", code: 0, error: 'failed', status: true}
        end
    end
end