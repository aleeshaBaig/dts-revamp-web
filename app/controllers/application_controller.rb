class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in? and current_user.lab_user?
      redirect_to patients_path, :alert => exception.message
    else
      redirect_to root_url, :alert => exception.message
    end

  end
  def success_msg(msg, reload = false, reload_table = false, modal_name = 'modal')
    js_reload = reload ? 'window.location.reload();' : check_reload_table(reload_table)
    js_str = "toastr.success('#{msg.gsub("'", '')}'); $('.#{modal_name}').modal('hide'); #{js_reload}";
    render js: js_str
  end
  def error_msg(msg, reload = false, custom_js = '')
    js_str = "toastr.error('#{msg.gsub("'", '')}'); #{reload ? 'window.location.reload();' : ''}; #{custom_js}"
    render js: js_str
  end
  def check_reload_table(reload_table)
    "setTimeout(function(){ window.location.reload() }, 1500);"
  end
	protected
    def after_sign_in_path_for(resource)
      if resource.admin?
        patients_path
      elsif resource.hospital_user? or resource.hospital_supervisor?
        home_hospital_users_path
      elsif resource.lab_user? or resource.lab_supervisor?
        home_lab_users_path
      elsif resource.dpc_user?
        patients_path
      elsif resource.department_user?
        heat_map_path
      elsif resource.tehsil_user?
        summary_of_activities_town_wise_path
      elsif resource.provisional_incharge?
        home_provincial_path
      elsif resource.phc_user?
        patients_path
      else
        patients_path
      end
    end  
    
    def after_sign_out_path_for(resource)
      new_user_session_path
    end
  
end
