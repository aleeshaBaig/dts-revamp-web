module SlideShowsHelper

	def activities
		if params[:mobile_username].present?
			user = MobileUser.filter_by_username(params[:mobile_username])
			if user.present?
				params[:user_id] = user.last.id
			else
				params[:user_id] = 0
			end
		end

	  if is_not_simple_activity?
	    PatientActivity.select(:id, :user_id, :tag_name, :before_picture, :patient_id, :created_at).accessible_by(current_ability, :read).includes(:user).filters(params).ascending.paginate(:page => params[:page], :per_page => 52)
	  else
	    SimpleActivity.select(:id, :user_id, :tag_name, :before_picture, :created_at).accessible_by(current_ability, :read).includes(:user).filters(params).ascending.paginate(:page => params[:page], :per_page => 52)
	  end
	end
	def is_not_simple_activity?
      params[:activity_type] != 'simple'
  	end
end