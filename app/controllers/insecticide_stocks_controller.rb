class InsecticideStocksController < ApplicationController
  before_action :set_insecticide_stock, only: %i[ show edit update destroy ]

  # GET /insecticide_stocks or /insecticide_stocks.json
  def index
    district_id = params[:district_id].present?? params[:district_id] : nil

    if district_id.present?
      @insecticide_stocks = InsecticideStock.accessible_by(current_ability).includes(:district, :user).joins(:district).where("insecticide_stocks.district_id = ?", district_id)
    else
      @insecticide_stocks = InsecticideStock.accessible_by(current_ability).includes(:district, :user)
    end
  end

  # GET /insecticide_stocks/1 or /insecticide_stocks/1.json
  def show
  end

  # GET /insecticide_stocks/new
  def new
    @insecticide_stock = InsecticideStock.new
  end

  # GET /insecticide_stocks/1/edit
  def edit
  end

  # POST /insecticide_stocks or /insecticide_stocks.json
  def create
    @insecticide_stock = InsecticideStock.new(insecticide_stock_params)

    respond_to do |format|
      if @insecticide_stock.save
        format.html { redirect_to insecticide_stocks_url, notice: "Insecticide stock was successfully created." }
        format.json { render :show, status: :created, location: @insecticide_stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @insecticide_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /insecticide_stocks/1 or /insecticide_stocks/1.json
  def update
    respond_to do |format|
      if @insecticide_stock.update(insecticide_stock_params)
        format.html { redirect_to insecticide_stocks_url, notice: "Insecticide stock was successfully updated." }
        format.json { render :show, status: :ok, location: @insecticide_stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @insecticide_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /insecticide_stocks/1 or /insecticide_stocks/1.json
  def destroy
    @insecticide_stock.destroy
    respond_to do |format|
      format.html { redirect_to insecticide_stocks_url, notice: "Insecticide stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_insecticide_stock
      @insecticide_stock = InsecticideStock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def insecticide_stock_params
      params.require(:insecticide_stock).permit(:insecticide_name, :stock_received, :stock_dispensed, :stock_in_hand, :district_id, :user_id)
    end
end
