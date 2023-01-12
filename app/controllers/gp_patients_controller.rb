  class GpPatientsController < ApplicationController

  def gp_patients_list
    authorize! :read, GpPatient

    p_page = params[:page]
    p_per_page = params[:per_page].present?? params[:per_page] : 30

    p_date_from = params[:d_from].present?? Time.parse(params[:d_from]) : nil
    p_date_to = params[:d_to].present?? Time.parse(params[:d_to]) : nil

    _date_from = "#{ ((p_date_from.present?)? ('gp_patients.created_at::DATE >= ' + '\'' + p_date_from.to_s + '\'') : 'true') }"
    _date_to = "#{ ((p_date_to.present?)? ('gp_patients.created_at::DATE <= ' + '\'' + p_date_to.to_s + '\'') : 'true') }"

    # q_where = "#{_date_from} AND #{_date_to}"

     _r_date = "#{ ((params[:r_date].present?)? ('reporting_date::DATE = ' + '\'' + Time.parse(params[:r_date]).to_s + '\'') : 'true') }"

     _prov_diagnosis = "#{ ((params[:prov_diagnosis].present?)? ('provisional_diagnosis = ' + '\'' + params[:prov_diagnosis] + '\'') : 'true') }"

     _cnic = "#{ ((params[:cnic].present?)? ('cnic like ' + '\'' + "%#{params[:cnic]}%" + '\'') : 'true') }"

     _p_name = "#{ ((params[:p_name].present?)? ('lower(patient_name) like ' + '\'' + "%#{params[:p_name].try(:downcase)}%" + '\'') : 'true') }"

     _added_by = "#{ ((params[:added_by].present?)? ('lower(gp_users.name) like ' + '\'' + "%#{params[:added_by].try(:downcase)}%" + '\'') : 'true') }"
     _district = "#{ ((params[:district].present?)? ('district_id = ' + '\'' + params[:district] + '\'') : 'true') }"
     _tehsil = "#{ ((params[:tehsil].present?)? ('tehsil_id = ' + '\'' + params[:tehsil] + '\'') : 'true') }"
     _uc = "#{ ((params[:uc].present?)? ('uc_id = ' + '\'' + params[:uc] + '\'') : 'true') }"

    @patients = GpPatient.accessible_by(current_ability).joins(:gp_user).where("#{_date_from} and #{_date_to} and #{_r_date} and #{_prov_diagnosis} and #{_cnic} and #{_p_name} and #{_added_by} and #{_district} and #{_tehsil} and #{_uc}").order("created_at DESC")

    respond_to do |format|
      format.html{
        @patients = @patients.paginate(:page => params[:page], :per_page => p_per_page)
      }
      format.json { render json: @patients }
      format.xls
    end
  end
end
