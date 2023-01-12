class Activities::VectorSurveillancesController < Activities::ApplicationController
	
	def line_list
		authorize! :read, ContainerTag

		if params[:pagination] == "No"
			@per_page = 100000		
		else
			@per_page = 20
		end
		params[:activity_type] = 'indoor' unless params[:activity_type].present?
        
		@activities = ContainerTag.includes(:surveillance_activity, :mobile_user).accessible_by(current_ability, :read).filters(params).ascending.paginate(:page => params[:page], :per_page => @per_page)
	end
end