class PcrMachinesController < ApplicationController
  before_action :set_pcr_machine, only: %i[ show edit update destroy ]

  # GET /pcr_machines or /pcr_machines.json
  def index
    hospital_category = params[:hospital_category].present?? params[:hospital_category] : nil
    facility_type = params[:facility_type].present?? params[:facility_type] : nil

    if hospital_category.present? and facility_type.present?
      @pcr_machines = PcrMachine.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.category = ? and hospitals.facility_type = ?", hospital_category, facility_type)
    elsif hospital_category.present?
      @pcr_machines = PcrMachine.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.category = ?", hospital_category)
    elsif facility_type.present?
      @pcr_machines = PcrMachine.accessible_by(current_ability).includes(:hospital, :user).joins(:hospital).where("hospitals.facility_type = ?", facility_type)
    else
      @pcr_machines = PcrMachine.accessible_by(current_ability).includes(:hospital, :user)
    end
  end

  # GET /pcr_machines/1 or /pcr_machines/1.json
  def show
  end

  # GET /pcr_machines/new
  def new
    @pcr_machine = PcrMachine.new
  end

  # GET /pcr_machines/1/edit
  def edit
  end

  # POST /pcr_machines or /pcr_machines.json
  def create
    @pcr_machine = PcrMachine.new(pcr_machine_params)

    respond_to do |format|
      if @pcr_machine.save
        format.html { redirect_to pcr_machines_url, notice: "Pcr machine was successfully created." }
        format.json { render :show, status: :created, location: @pcr_machine }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pcr_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pcr_machines/1 or /pcr_machines/1.json
  def update
    respond_to do |format|
      if @pcr_machine.update(pcr_machine_params)
        format.html { redirect_to pcr_machines_url, notice: "Pcr machine was successfully updated." }
        format.json { render :show, status: :ok, location: @pcr_machine }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pcr_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pcr_machines/1 or /pcr_machines/1.json
  def destroy
    @pcr_machine.destroy
    respond_to do |format|
      format.html { redirect_to pcr_machines_url, notice: "Pcr machine was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pcr_machine
      @pcr_machine = PcrMachine.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pcr_machine_params
      params.require(:pcr_machine).permit(:pcr_functional, :pcr_non_functional, :total_pcr_machines, :hospital_id, :user_id)
    end
end
