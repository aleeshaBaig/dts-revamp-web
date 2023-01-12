class BedsController < ApplicationController
  before_action :set_bed, only: %i[ show edit update destroy]
  load_and_authorize_resource

  # GET /beds or /beds.json
  def index
    @beds = BedSearchService.new(current_ability).run(params)
    respond_to do |format|
      format.html { @beds = @beds.paginate(:page => params[:page], :per_page => 200)}
      format.xls { }
    end
  end

  # GET /beds/1 or /beds/1.json
  def show
  end

  # GET /beds/new
  def new
    bed = Bed.find_by_hospital_id(current_user.hospital_id)
    if bed.present?
      redirect_to edit_bed_url(bed.id)
    else
      @bed = Bed.new(hospital_id: current_user.hospital_id)
    end
  end

  # GET /beds/1/edit
  def edit
  end

  # POST /beds
  # POST /beds.json
  def create
    @bed = Bed.new(bed_params)
    @bed.hospital_id = current_user.hospital_id unless @bed.hospital_id.present?
    respond_to do |format|
      if @bed.save
        format.html { redirect_to beds_url, notice: 'Bed Occupancy information is created successfully.' }
        format.json { render :show, status: :created, location: @bed }
      else
        format.html { render :new }
        format.json { render json: @bed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beds/1
  # PATCH/PUT /beds/1.json
  def update
    @bed.last_updated_at = Time.now if current_user.hospital_user? and @bed.is_update_columns?(bed_params)
    
    respond_to do |format|
      if @bed.update(bed_params)
        format.html { redirect_to beds_url, notice: 'Bed Occupancy information is updated successfully.' }
        format.json { render :show, status: :ok, location: @bed }
      else
        format.html { render :edit }
        format.json { render json: @bed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beds/1
  # DELETE /beds/1.json
  def destroy
    @bed.destroy
    respond_to do |format|
      format.html { redirect_to beds_url, notice: 'Bed Occupancy information is deleted successfully.' }
      format.json { head :no_content }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bed
      @bed = Bed.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bed_params
      params.require(:bed).permit(:total_ward_beds, :total_hdu_beds, :hospital_id, :ward_beds_ramp_up, :hdu_beds_ramp_up)
    end
  end
