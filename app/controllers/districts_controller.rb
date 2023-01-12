class DistrictsController < ApplicationController
  before_action :set_district, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /districts
  # GET /districts.json
  def index
    if params[:pagination] == "No"
      per_page = 100000
    else
      per_page = 20
    end

    q_prov = params[:province_id].present? ? "province_id = '#{params[:province_id]}'" : 'true'
    q_div = params[:division_id].present? ? "division_id = '#{params[:division_id]}'" : 'true'
    q_dis = params[:district_id].present? ? "id = '#{params[:district_id]}'" : 'true'

    @districts = District.includes(:province,:division).where("#{q_prov} and #{q_dis} and #{q_div}").paginate(:page => params[:page], :per_page => per_page).order("created_at desc")
    respond_to do |format|
      format.html 
      format.xls
    end
  end

  # GET /districts/1
  # GET /districts/1.json
  def show
  end

  # GET /districts/new
  def new
    @district = District.new
  end

  # GET /districts/1/edit
  def edit
  end

  # POST /districts
  # POST /districts.json
  def create
    @district = District.new(district_params)

    respond_to do |format|
      if @district.save
        format.html { redirect_to districts_url, notice: 'District was successfully created.' }
        format.json { render :show, status: :created, location: @district }
      else
        format.html { render :new }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /districts/1
  # PATCH/PUT /districts/1.json
  def update
    respond_to do |format|
      if @district.update(district_params)
        format.html { redirect_to districts_url, notice: 'District was successfully updated.' }
        format.json { render :show, status: :ok, location: @district }
      else
        format.html { render :edit }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /districts/1
  # DELETE /districts/1.json
  def destroy
    @district.destroy
    respond_to do |format|
      format.html { redirect_to districts_url, notice: 'District was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_district
      @district = District.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def district_params
      params.require(:district).permit(:district_name, :province_id, :division_id)
    end
end
