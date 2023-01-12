class Activities::SimplesController < Activities::ApplicationController
	include ApplicationHelper

	def line_list
		authorize! :read, SimpleActivity
		per_page = per_page_items(100000)
		
		if params.has_key? :datefrom
			@activities = SimpleActivity.select("simple_activities.id, simple_activities.district_name, simple_activities.tehsil_name, simple_activities.uc_name, simple_activities.department_name, simple_activities.tag_name, simple_activities.larva_found, simple_activities.larva_type, simple_activities.latitude, simple_activities.longitude, simple_activities.created_at, simple_activities.is_bogus, simple_activities.user_id, simple_activities.before_picture, simple_activities.after_picture, simple_activities.pdif_time").accessible_by(current_ability, :read).includes(:user).filters(params).ascending.paginate(:page => params[:page], :per_page => per_page)
		else
			@activities = []
		end
	end

	def mark_act_bogus
		simple_activity = SimpleActivity.find(params[:activity_id])
    	authorize! :mark_act_bogus, simple_activity
    	if simple_activity.is_bogus == false or simple_activity.is_bogus == nil 
      		simple_activity.update_attributes(:is_bogus => true)
    	end

    	current_page = params[:page].present? ? params[:page] : "1"

    	respond_to do |format|
      		format.html { redirect_back fallback_location: root_path, notice: 'Activity has been marked bogus successfully.' }
    	end
	end

	def bogus_activities
		authorize! :read, SimpleActivity

		per_page = per_page_items(10)
		
		if params.has_key? :datefrom
			@activities = SimpleActivity.select("simple_activities.id, simple_activities.district_name, simple_activities.tehsil_name, simple_activities.uc_name, simple_activities.department_name, simple_activities.tag_name, simple_activities.larva_found, simple_activities.larva_type, simple_activities.latitude, simple_activities.longitude, simple_activities.created_at, simple_activities.is_bogus, simple_activities.user_id, simple_activities.before_picture, simple_activities.after_picture").accessible_by(current_ability, :read).where("is_bogus is true").filters(params).ascending.paginate(:page => params[:page], :per_page => per_page)
		else
			@activities = []
		end
	end
end