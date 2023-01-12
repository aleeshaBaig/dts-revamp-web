class GpDengueUsersController < ApplicationController
  layout 'adminpanel'
  load_and_authorize_resource

  def index
    @gp_dengue_users = GpDengueUserSearchService.new(current_ability).run(params)
    respond_to do |format|
      format.html { @gp_dengue_users = @gp_dengue_users.paginate(:page => params[:page], :per_page => 200)}
      format.xls { }
    end
  end
end
