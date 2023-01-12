class Reports::ApplicationController < ActionController::Base
  layout 'adminpanel'
	rescue_from CanCan::AccessDenied do |exception|
	  if user_signed_in? and current_user.lab_user?
      redirect_to lab_patients_path, :alert => exception.message
    else
      redirect_to root_url, :alert => exception.message
    end
	end
end