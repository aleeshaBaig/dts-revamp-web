class PpeStocksController < ApplicationController
  before_action :set_ppe_stock, only: %i[ show edit update destroy ]

  # GET /ppe_stocks or /ppe_stocks.json
  def index
    hospital_category = params[:hospital_category].present?? params[:hospital_category] : nil
    facility_type = params[:facility_type].present?? params[:facility_type] : nil

    if hospital_category.present? and facility_type.present?
      @ppe_stocks = PpeStock.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.category = ? and hospitals.facility_type = ?", hospital_category, facility_type)
    elsif hospital_category.present?
      @ppe_stocks = PpeStock.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.category = ?", hospital_category)
    elsif facility_type.present?
      @ppe_stocks = PpeStock.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.facility_type = ?", facility_type)
    else
      @ppe_stocks = PpeStock.accessible_by(current_ability).includes(:hospital, :user)
    end
  end

  # GET /ppe_stocks/1 or /ppe_stocks/1.json
  def show
  end

  # GET /ppe_stocks/new
  def new
    @ppe_stock = PpeStock.new
  end

  # GET /ppe_stocks/1/edit
  def edit
  end

  # POST /ppe_stocks or /ppe_stocks.json
  def create
    @ppe_stock = PpeStock.new(ppe_stock_params)

    respond_to do |format|
      if @ppe_stock.save
        format.html { redirect_to ppe_stocks_url, notice: "Ppe stock was successfully created." }
        format.json { render :show, status: :created, location: @ppe_stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ppe_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ppe_stocks/1 or /ppe_stocks/1.json
  def update
    respond_to do |format|
      if @ppe_stock.update(ppe_stock_params)
        format.html { redirect_to ppe_stocks_url, notice: "Ppe stock was successfully updated." }
        format.json { render :show, status: :ok, location: @ppe_stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ppe_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ppe_stocks/1 or /ppe_stocks/1.json
  def destroy
    @ppe_stock.destroy
    respond_to do |format|
      format.html { redirect_to ppe_stocks_url, notice: "Ppe stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ppe_stock
      @ppe_stock = PpeStock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ppe_stock_params
      params.require(:ppe_stock).permit(:ppe_name, :stock_received, :stock_dispensed, :stock_in_hand, :hospital_id, :user_id)
    end
end
