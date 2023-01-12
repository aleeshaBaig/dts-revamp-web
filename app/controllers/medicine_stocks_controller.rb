class MedicineStocksController < ApplicationController
  before_action :set_medicine_stock, only: %i[ show edit update destroy ]

  # GET /medicine_stocks or /medicine_stocks.json
  def index
    hospital_category = params[:hospital_category].present?? params[:hospital_category] : nil
    facility_type = params[:facility_type].present?? params[:facility_type] : nil

    if hospital_category.present? and facility_type.present?
      @medicine_stocks = MedicineStock.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.category = ? and hospitals.facility_type = ?", hospital_category, facility_type)
    elsif hospital_category.present?
      @medicine_stocks = MedicineStock.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.category = ?", hospital_category)
    elsif facility_type.present?
      @medicine_stocks = MedicineStock.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.facility_type = ?", facility_type)
    else
      @medicine_stocks = MedicineStock.accessible_by(current_ability).includes(:hospital, :user)
    end
  end

  # GET /medicine_stocks/1 or /medicine_stocks/1.json
  def show
  end

  # GET /medicine_stocks/new
  def new
    @medicine_stock = MedicineStock.new
  end

  # GET /medicine_stocks/1/edit
  def edit
  end

  # POST /medicine_stocks or /medicine_stocks.json
  def create
    @medicine_stock = MedicineStock.new(medicine_stock_params)

    respond_to do |format|
      if @medicine_stock.save
        format.html { redirect_to medicine_stocks_url, notice: "Medicine stock was successfully created." }
        format.json { render :show, status: :created, location: @medicine_stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medicine_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medicine_stocks/1 or /medicine_stocks/1.json
  def update
    respond_to do |format|
      if @medicine_stock.update(medicine_stock_params)
        format.html { redirect_to medicine_stocks_url, notice: "Medicine stock was successfully updated." }
        format.json { render :show, status: :ok, location: @medicine_stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medicine_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medicine_stocks/1 or /medicine_stocks/1.json
  def destroy
    @medicine_stock.destroy
    respond_to do |format|
      format.html { redirect_to medicine_stocks_url, notice: "Medicine stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medicine_stock
      @medicine_stock = MedicineStock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medicine_stock_params
      params.require(:medicine_stock).permit(:medicine_name, :stock_received, :stock_dispensed, :stock_in_hand, :hospital_id, :user_id)
    end
end
