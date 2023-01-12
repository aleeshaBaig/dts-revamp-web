class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :authenticate_user!
  include ApplicationHelper
  
  layout "adminpanel"
  # GET /users
  # GET /users.json
  def change_password
    @user = User.find(params[:user_id])
    respond_to { |format| format.js }
  end
  def role_management
    @user = []
    user_id = params[:user_id]
    user_role = params[:role]
    if user_role.present?
      if user_id.present?
        @user = User.find(user_id)
        @user.role = user_role
      else
        @user = User.new(role: user_role)
      end
    end
    respond_to { |format| format.js }
  end

  def index
    per_page = per_page_items(100000)
    @users=User
      .accessible_by(current_ability, :read)
      .select("id, username, email, department_id, role, last_sign_in_at, current_sign_in_at, sign_in_count").includes(:department)
      .filters(params)
      .paginate(:page => params[:page], :per_page => per_page).order("created_at DESC")
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      user_success_msg('User is created')
    else
      error_msg @user.errors.full_messages.to_sentence
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
       user_success_msg 'User Info is updated!'
    else
      puts "====#{@user.errors.messages}"
      error_msg @user.errors.full_messages.to_sentence
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User is deleted successfully.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :role, :district_id, :hospital_id, :lab_id, :department_id, :tehsil_id, :is_forgot, :status, :hotspot_status, :is_third_party_audit)
    end
    def user_success_msg(msg, reload = false, reload_table = false, modal_name = 'modal')
      js_reload = user_check_reload_table
      js_str = "toastr.success('#{msg.gsub("'", '')}'); $('.#{modal_name}').modal('hide'); #{js_reload}";
      render js: js_str
    end
    def user_check_reload_table
      "setTimeout(function(){ window.location.href = '/users' }, 1500);"
    end
end
