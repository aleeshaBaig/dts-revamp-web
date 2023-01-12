class LabsController < ApplicationController
  before_action :set_lab, only: [:show, :edit, :update, :destroy]

  # GET /labs
  # GET /labs.json
  def index
     if request.format == "xls"
      @per_page = 100000
    else
      @per_page = 20
    end
    @labs = Lab.includes(:district)
    @labs = @labs.where(nil)
    if params.present?
      lab_filter_params(params).each do |key, value|
        @labs = @labs.public_send(key, value) if value.present?
      end
    end
    respond_to do |format|
      format.html{
        @labs = @labs.order("lab_name ASC").paginate(:page => params[:page], :per_page => @per_page)
      }
      format.xls{
        @labs = @labs.order("lab_name ASC").paginate(:page => params[:page], :per_page => @per_page)
      }
      format.json{
        @labs.order("lab_name ASC")
      }
    end
  end

  # GET /labs/1
  # GET /labs/1.json
  def show
  end

  # GET /labs/new
  def new
    @lab = Lab.new
  end

  # GET /labs/1/edit
  def edit
  end

  # POST /labs
  # POST /labs.json
  def create
    @lab = Lab.new(lab_params)

    respond_to do |format|
      if @lab.save
        format.html { redirect_to labs_url, notice: 'Lab was successfully created.' }
        format.json { render :show, status: :created, location: @lab }
      else
        format.html { render :new }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /labs/1
  # PATCH/PUT /labs/1.json
  def update
    respond_to do |format|
      if @lab.update(lab_params)
        format.html { redirect_to @lab, notice: 'Lab was successfully updated.' }
        format.json { render :show, status: :ok, location: @lab }
      else
        format.html { render :edit }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labs/1
  # DELETE /labs/1.json
  def destroy
    @lab.destroy
    respond_to do |format|
      format.html { redirect_to labs_url, notice: 'Lab was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lab
      @lab = Lab.find(params[:id])
    end

     # Only allow a list of trusted parameters through.
    def lab_filter_params(params)
      params.slice(:lab_name, :lab_type, :district_id)
    end

    # Only allow a list of trusted parameters through.
    def lab_params
      params.require(:lab).permit(:lab_name, :district_id, :lab_type)
    end
end
