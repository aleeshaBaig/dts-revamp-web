class Api::V1::ActivitiesController < Api::ApplicationController
	def submit_data
		json_data = JSON.parse(params[:data])
		command = json_data['category_name'] == 'Patient' ? PatientActivityApi.call(json_data, params[:before_picture], params[:after_picture], current_api_user) : SimpleActivityApi.call(json_data, params[:before_picture], params[:after_picture], current_api_user)
	    if command.success?
	      render json: {code: 200, status: true, message: 'Activity has been Submitted Successfully', response: command.result}
	    else
	      render json: {error: 1, code: 0, message: command.errors.full_messages.to_sentence, status: false}
	    end
	end
end