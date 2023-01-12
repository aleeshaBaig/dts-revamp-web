class GpDenguePatientsController < ApplicationController
  layout 'adminpanel'
  load_and_authorize_resource

  def index
    @gp_dengue_patients = GpDenguePatientSearchService.new(current_ability).run(params)
    respond_to do |format|
      format.html { @gp_dengue_patients = @gp_dengue_patients.paginate(:page => params[:page], :per_page => 200)}
      format.xls { }
    end
  end
end
