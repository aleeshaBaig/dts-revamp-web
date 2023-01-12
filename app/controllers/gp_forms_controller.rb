class GpFormsController < ApplicationController
    layout 'adminpanel'
    load_and_authorize_resource
  
    def index
      @gp_forms = GpFormSearchService.new(current_ability).run(params)
      respond_to do |format|
        format.html { @gp_forms = @gp_forms.paginate(:page => params[:page], :per_page => 200)}
        format.xls { }
      end
    end
end
  