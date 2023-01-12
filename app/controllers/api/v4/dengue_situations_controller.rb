class Api::V4::DengueSituationsController < Api::ApplicationController
	def submit_data
		command = DengueSituationApi.call(params[:data], current_api_user)
    if command.success?
      render json: {code: 200, status: true, message: 'Data has been saved successfully', response: command.result}
    else
      render json: {error: 1, code: 0, message: command.errors.full_messages.to_sentence, status: false}
    end
	end
  
  def line_listing

    q_district_id = "true"
    q_entery_date = "true"

    ## role wise date populate
    q_district_id = "district_id = '#{current_api_user.district_id}'" if current_api_user.is_district_user?
    if current_api_user.is_divisional_user?
      if params[:district_id].present?
        q_district_id = "district_id = '#{params[:district_id]}'"
      else        
        
        district_ids = current_api_user.division.districts.map(&:id).join(',') rescue "0"
        q_district_id = "district_id IN(#{district_ids})"
      end
    end

    ## entery date
    if params[:date_from].present? and params[:date_to].present?
      q_entery_date = "entery_date between '#{params[:date_from]}' and '#{params[:date_to]}'"
    end


    ## Query
    dengue_situation = DengueSituation.select("sum(confirmed_patient) as confirmed_patient, sum(patient_reported_by_lab) as patient_reported_by_lab, sum(patient_reported_by_hospital) as patient_reported_by_hospital, sum(death) as death, sum(admissions) as admissions, sum(case_reponse) as case_reponse, sum(indoor_positive_larvae) as indoor_positive_larvae, sum(outdoor_positive_larvae) as outdoor_positive_larvae, sum(hotspots_coverage) as hotspots_coverage, sum(dormant_users) as dormant_users, sum(firs) as firs, sum(notices_served) as notices_served, sum(premises_sealed) as premises_sealed, sum(arrests) as arrests, sum(fines_imposed) as fines_imposed, sum(dvrs_total) as dvrs_total, sum(dvrs_resolved) as dvrs_resolved, sum(dvrs_pending) as dvrs_pending").where("#{q_district_id} and #{q_entery_date}")
    
    ## Response
    render json: {data: dengue_situation.as_json(:except => ([:id])), code: 200, status: true}
  end
  
  private
  def filtering_params(params)
    params.slice(:datefrom, :dateto, :district_id)
  end
end