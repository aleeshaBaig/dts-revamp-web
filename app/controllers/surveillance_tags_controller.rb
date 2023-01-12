class SurveillanceTagsController < ApplicationController
  before_action :set_surveillance_tag, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  
  # GET /surveillance_tags or /surveillance_tags.json
  def index
    @surveillance_tags = SurveillanceTag.all
  end

  # GET /surveillance_tags/1 or /surveillance_tags/1.json
  def show
  end

  # GET /surveillance_tags/new
  def new
    @surveillance_tag = SurveillanceTag.new
  end

  # GET /surveillance_tags/1/edit
  def edit
  end

  # POST /surveillance_tags or /surveillance_tags.json
  def create
    @surveillance_tag = SurveillanceTag.new(surveillance_tag_params)

    respond_to do |format|
      if @surveillance_tag.save
        format.html { redirect_to @surveillance_tag, notice: "Surveillance tag was successfully created." }
        format.json { render :show, status: :created, location: @surveillance_tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @surveillance_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surveillance_tags/1 or /surveillance_tags/1.json
  def update
    respond_to do |format|
      if @surveillance_tag.update(surveillance_tag_params)
        format.html { redirect_to @surveillance_tag, notice: "Surveillance tag was successfully updated." }
        format.json { render :show, status: :ok, location: @surveillance_tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @surveillance_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveillance_tags/1 or /surveillance_tags/1.json
  def destroy
    @surveillance_tag.destroy
    respond_to do |format|
      format.html { redirect_to surveillance_tags_url, notice: "Surveillance tag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_surveillance_tag
      @surveillance_tag = SurveillanceTag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def surveillance_tag_params
      params.require(:surveillance_tag).permit(:name, :tag_type)
    end
end
