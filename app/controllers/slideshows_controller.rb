class SlideshowsController < ApplicationController
  before_action :set_slideshow, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  layout 'slideshow'
  include SlideShowsHelper

  # GET /slideshows or /slideshows.json

  def download_as_pdf
    activities_ids = params[:activity_ids].split(',')
    if is_not_simple_activity?
      @slideshow_activities = PatientActivity.where('id IN (?)', activities_ids).includes(:picture).paginate(:per_page => 50, :page => params[:page]) 

    else
      @slideshow_activities = SimpleActivity.where('id IN (?)', activities_ids).includes(:picture).paginate(:per_page => 50, :page => params[:page]) 
    end

    respond_to do |format|
      format.html
      format.pdf do
      render :pdf => "#{params[:department]} Slideshow",
             :orientation => 'Landscape'
      end
    end
  end
  def download_as_image
    activities_ids = params[:activity_ids].split(',')
    if is_not_simple_activity?
      @slideshow_activities = PatientActivity.where('id IN (?)', activities_ids).includes(:picture).paginate(:per_page => 50, :page => params[:page]) 

    else
      @slideshow_activities = SimpleActivity.where('id IN (?)', activities_ids).includes(:picture).paginate(:per_page => 50, :page => params[:page]) 
    end

    respond_to do |format|
      format.html
      format.pdf do
      render :pdf => "Slideshow",
             :orientation => 'Landscape'
      end
    end
  end

  def index
    @slideshows = Slideshow.accessible_by(current_ability, :read).includes(:user, :department).filters(params).ascending.paginate(:page => params[:page], :per_page => 50)
  end

  # GET /slideshows/1 or /slideshows/1.json
  def show
  end

  # GET /slideshows/new
  def new
    (params[:activity_type] = 'patient') unless params[:activity_type].present?
    @slideshow = Slideshow.new
  end

  # GET /slideshows/1/edit
  def edit
    if @slideshow.activity_type.present?
      params[:activity_type] = @slideshow.activity_type
    else
      params[:activity_type] = 'patient'
    end
  end

  # POST /slideshows or /slideshows.json
  def create
    @slideshow = Slideshow.new(slideshow_params)
    @slideshow.user_id = current_user.id
    (@slideshow.department_id = current_user.department_id)

    respond_to do |format|
      if @slideshow.save
        format.html { redirect_to slideshows_url, notice: "Slide Show is created successfully" }
        format.json { render :show, status: :created, location: @slideshow }
      else
        
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @slideshow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slideshows/1 or /slideshows/1.json
  def update
    respond_to do |format|
      if @slideshow.update(slideshow_params)
        format.html { redirect_to slideshows_url, notice: "Slide Show is updated successfully" }
        format.json { render :show, status: :ok, location: @slideshow }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @slideshow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slideshows/1 or /slideshows/1.json
  def destroy
    @slideshow.destroy
    respond_to do |format|
      format.html { redirect_to slideshows_url, notice: "Slide Show is deleted successfully" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slideshow
      @slideshow = Slideshow.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def slideshow_params
      params.require(:slideshow).permit(:name, :activity_type, :user_id, :department_id, activity_ids: [])
    end
end
