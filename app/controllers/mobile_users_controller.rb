class MobileUsersController < ApplicationController
  before_action :set_mobile_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  layout "adminpanel"

  def index
    if request.format == "xls"
      @per_page = 100000
    else
      @per_page = 20
    end
    @mobile_users = MobileUser.all
    @mobile_users = @mobile_users.includes(:tehsils, :tag_categories, :department).where(nil)
    if params.present?
      mobile_user_filter_params(params).each do |key, value|
        @mobile_users = @mobile_users.public_send(key, value) if value.present?
      end
    end
    @mobile_users = @mobile_users.order("created_at DESC").paginate(:page => params[:page], :per_page => @per_page)

    respond_to do |format|
      format.html 
      format.xls
    end
  end  
  def new
    @mobile_user = MobileUser.new
  end
  def change_password
    @mobile_user = MobileUser.find(params[:user_id])
    respond_to { |format| format.js }
  end

  def create
    @mobile_user = MobileUser.new(mobile_user_params)
    respond_to do |format|
      if @mobile_user.save
        format.html { redirect_to mobile_users_url, notice: 'Mobile user is created successfully.' }
        format.json { render :show, status: :created, location: @mobile_user }
      else
        format.html { render :new }
        format.json { render json: @mobile_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if params["is_forgot"] == "true"
      if @mobile_user.update(mobile_user_params)
        user_success_msg 'Mobile User is updated!'
        # jwt_token = JsonWebToken.encode(user_id: @mobile_user.id)
        # if jwt_token.present?
        #   if JsonWebToken.decode(jwt_token)
        #     user_success_msg 'Mobile User is updated!'
        #   else
        #     user_success_msg 'Mobile User is updated! but Mobile Session not rest'  
        #   end
        # else
        #   user_success_msg 'Mobile User is updated! but Mobile Session not rest'
        # end
      else
        error_msg @mobile_user.errors.full_messages.to_sentence
      end
    else
      respond_to do |format|
        if @mobile_user.update(mobile_user_params)
          format.html { redirect_to mobile_users_url, notice: 'Mobile user is updated successfully.' }
          format.json { render :show, status: :ok, location: @mobile_user }
        else
          # puts "===========#{@mobile_user.errors.messages}"
          format.html { render :edit }
          format.json { render json: @mobile_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @mobile_user.destroy
    respond_to do |format|
      format.html { redirect_to mobile_users_url, notice: 'Mobile User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mobile_user
      @mobile_user = MobileUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mobile_user_filter_params(params)
      params.slice( :role, :username, :district_id, :tehsil_id, :status)
    end

    def mobile_user_params
      params.require(:mobile_user).permit(:division_id, :username, :role, :status, :is_surveillance, :password, :password_confirmation, :district_id, :department_id, :is_forgot, tehsil_ids: [], tag_category_ids: [])
    end
    def user_success_msg(msg, reload = false, reload_table = false, modal_name = 'modal')
      js_reload = user_check_reload_table
      js_str = "toastr.success('#{msg.gsub("'", '')}'); $('.#{modal_name}').modal('hide'); #{js_reload}";
      render js: js_str
    end
    def user_check_reload_table
      "setTimeout(function(){ window.location.href = '/mobile_users' }, 1500);"
    end
end