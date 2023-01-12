class TehsilsController < ApplicationController
  before_action :set_tehsil, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /tehsils
  # GET /tehsils.json
  def index
    
    if params[:pagination] == "No"
      per_page = 1000000
    else
      per_page = 20
    end

    q_prov = params[:province_id].present? ? "province_id = '#{params[:province_id]}'" : 'true'
    q_div = params[:division_id].present? ? "division_id = '#{params[:division_id]}'" : 'true'
    q_dis = params[:district_id].present? ? "district_id = '#{params[:district_id]}'" : 'true'
    q_t_name = params[:t_name].present? ? "lower(tehsil_name) like '%#{params[:t_name].downcase}%'" : 'true'

    @tehsils = Tehsil.accessible_by(current_ability, :read).joins(:district).where("#{q_prov} and #{q_div} and #{q_dis} and #{q_t_name}").order("created_at DESC").paginate(:page => params[:page], :per_page => per_page)
    respond_to do |format|
      format.html 
      format.xls
      format.json{@tehsils}
    end
  end

  # GET /tehsils/1
  # GET /tehsils/1.json
  def show
  end

  # GET /tehsils/new
  def new
    @tehsil = Tehsil.new
  end

  # GET /tehsils/1/edit
  def edit
  end

  # POST /tehsils
  # POST /tehsils.json
  def create
    @tehsil = Tehsil.new(tehsil_params)

    respond_to do |format|
      if @tehsil.save
        format.html { redirect_to tehsils_url, notice: 'Tehsil is created successfully.' }
        format.json { render :show, status: :created, location: @tehsil }
      else
        format.html { render :new }
        format.json { render json: @tehsil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tehsils/1
  # PATCH/PUT /tehsils/1.json
  def update
    respond_to do |format|
      if @tehsil.update(tehsil_params)
        format.html { redirect_to tehsils_url, notice: 'Tehsil is updated successfully.' }
        format.json { render :show, status: :ok, location: @tehsil }
      else
        format.html { render :edit }
        format.json { render json: @tehsil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tehsils/1
  # DELETE /tehsils/1.json
  def destroy
    @tehsil.destroy
    respond_to do |format|
      format.html { redirect_to tehsils_url, notice: 'Tehsil was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tehsil
      @tehsil = Tehsil.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tehsil_params
      params.require(:tehsil).permit(:tehsil_name, :district_id)
    end
end
