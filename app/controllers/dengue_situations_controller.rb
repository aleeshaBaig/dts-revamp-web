class DengueSituationsController < ApplicationController
  layout 'adminpanel'
  load_and_authorize_resource
  
  def index
    @dengue_situations = DengueSituationSearchService.new(current_ability).run(params)
    respond_to do |format|
      format.html {@dengue_situations = @dengue_situations.paginate(:page => params[:page], :per_page => PER_PAGE)}
      format.csv {send_data (@dengue_situations.to_csv(current_user)), filename: "dengue-situation-#{Date.today}.csv", layout: false, type: 'text/csv;chartset=utf-8'}
    end
  end
  
end


