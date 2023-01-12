class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  # # POST /resource/sign_in
  def create
    success = verify_recaptcha(action: 'login', minimum_score: 0.5, secret_key: ENV['RECAPTCHA_SECRET_KEY_V3'])
    checkbox_success = verify_recaptcha unless success

    if success || checkbox_success || Rails.env.development? || (current_user.present? and current_user.admin?)
      super
    else
      if !success
        @show_checkbox_recaptcha = true
      end
      clean_up_passwords(resource)
      flash[:recaptcha_error] = "Incorrect Captcha"
      respond_with resource, location: new_user_session_path
    end
  end

end
