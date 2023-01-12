class HotspotsController < ApplicationController
  before_action :set_hotspot, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /hotspots
  # GET /hotspots.json
  def index
    @hotspots = Hotspot.accessible_by(current_ability).includes(:updated_by).filters(params).order("created_at DESC")
    respond_to do |format|
      format.html{
        @hotspots = @hotspots.paginate(:page => params[:page], :per_page => 50)
      }
      format.xls
    end
  end

  # GET /hotspots/1
  # GET /hotspots/1.json
  def show
  end

  # GET /hotspots/new
  def new
    # @tags = Tag.select("tag_name").where("tag_category_id = ?", 15).order("tag_name ASC").collect{|p| [p.tag_name]}
    @hotspot = Hotspot.new
  end

  # GET /hotspots/1/edit
  def edit
    @tags = Tag.select("tag_name").order("tag_name ASC").collect{|p| [p.tag_name]}
  end

  # POST /hotspots
  # POST /hotspots.json
  def create
    @hotspot = Hotspot.new(hotspot_params)

    respond_to do |format|
      if @hotspot.save
        format.html { redirect_to hotspots_url, notice: 'Hotspot is created successfully.' }
        format.json { render :show, status: :created, location: @hotspot }
      else
        format.html { render :new }
        format.json { render json: @hotspot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotspots/1
  # PATCH/PUT /hotspots/1.json
  def update
    respond_to do |format|
      if @hotspot.update(hotspot_params)
        format.html { redirect_to hotspots_url, notice: 'Hotspot is updated successfully.' }
        format.json { render :show, status: :ok, location: @hotspot }
      else
        format.html { render :edit }
        format.json { render json: @hotspot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotspots/1
  # DELETE /hotspots/1.json
  def destroy
    @hotspot.destroy
    respond_to do |format|
      format.html { redirect_to hotspots_url, notice: 'Hotspot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotspot
      @hotspot = Hotspot.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hotspot_params
      params.require(:hotspot).permit(:hotspot_name,:tehsil, :uc, :address, :tag, :description, :name, :lat, :long, :district_id, :district, :is_active, :tehsil_id, :uc_id, :tag_id, :hotspot_updated_by)
    end
end
