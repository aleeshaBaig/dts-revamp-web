class Activities::PatientsController < Activities::ApplicationController
	include ApplicationHelper
	
	def line_list
		authorize! :read, PatientActivity

		per_page = per_page_items(100000)
		
		if params.has_key? :datefrom
			@activities = PatientActivity.accessible_by(current_ability, :read).includes(:patient, :user).filters(params).ascending.paginate(:page => params[:page], :per_page => per_page)
		else
			@activities = []
		end
		respond_to do |format|
      		format.html 
      		format.xls
    	end
	end

	def destroy
		PatientActivity.find_by(id: params[:id]).destroy
		# @activity.destroy
		respond_to do |format|
		  format.html { redirect_to "/activities/patients/line_list", notice: 'Activity was successfully destroyed.' }
		  format.json { head :no_content }
		end
	  end
end