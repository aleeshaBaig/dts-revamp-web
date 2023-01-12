class HospitalsController < ApplicationController
  before_action :set_hospital, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /hospitals
  # GET /hospitals.json
  def index
      if params[:pagination] == "No"
        @per_page = 100000
      else
        @per_page = 20
      end
    @hospitals = Hospital.accessible_by(current_ability).includes(:district)
    @hospitals = @hospitals.where(nil)
    if params.present?
      hospital_filter_params(params).each do |key, value|
        @hospitals = @hospitals.public_send(key, value) if value.present?
      end
    end
    
    respond_to do |format|
      format.html{
        @hospitals = @hospitals.order("created_at DESC").paginate(:page => params[:page], :per_page => @per_page)
      }
      format.xls{
        @hospitals = @hospitals.order("created_at DESC")
      }
      format.json{@hospitals.order("created_at DESC")}
    end
  end

  # GET /hospitals/1
  # GET /hospitals/1.json
  def show
  end

  # GET /hospitals/new
  def new
    @hospital = Hospital.new
  end

  # GET /hospitals/1/edit
  def edit
  end

  # POST /hospitals
  # POST /hospitals.json
  def create
    @hospital = Hospital.new(hospital_params)

    respond_to do |format|
      if @hospital.save
        format.html { redirect_to hospitals_url, notice: 'Hospital is created successfully.' }
        format.json { render :show, status: :created, location: @hospital }
      else
        format.html { render :new }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hospitals/1
  # PATCH/PUT /hospitals/1.json
  def update
    respond_to do |format|
      if @hospital.update(hospital_params)
        format.html { redirect_to hospitals_url, notice: 'Hospital is updated successfully.' }
        format.json { render :show, status: :ok, location: @hospital }
      else
        format.html { render :edit }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hospitals/1
  # DELETE /hospitals/1.json
  def destroy
    @hospital.destroy
    respond_to do |format|
      format.html { redirect_to hospitals_url, notice: 'Hospital was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hospital
      @hospital = Hospital.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hospital_filter_params(params)
      params.slice(:hospital_id, :facility_type,:category,:district_id, :province_id)
    end

    def hospital_params
      params.require(:hospital).permit(:hospital_name, :hospital_id, :district_id, :facility_type, :category, :province_id)
    end
end
