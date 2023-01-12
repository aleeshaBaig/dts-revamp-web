class DengueSituationApi
  prepend SimpleCommand
  include ApplicationHelper
  include ActiveModel::Validations
  
  def initialize(params, current_api_user)  
    @confirmed_patient = params["confirmed_patient"]
    @patient_reported_by_lab = params["patient_reported_by_lab"]
    @patient_reported_by_hospital = params["patient_reported_by_hospital"]
    @death = params["death"]
    @admissions = params["admissions"]
    @case_reponse = params["case_reponse"]
    @indoor_positive_larvae = params["indoor_positive_larvae"]
    @outdoor_positive_larvae = params["outdoor_positive_larvae"]
    @hotspots_coverage = params["hotspots_coverage"]
    @dormant_users = params["dormant_users"]
    @firs = params["firs"]
    @notices_served = params["notices_served"]
    @premises_sealed = params["premises_sealed"]
    @arrests = params["arrests"]
    @fines_imposed = params["fines_imposed"]
    @dvrs_total = params["dvrs_total"]
    @dvrs_resolved = params["dvrs_resolved"]
    @dvrs_pending = params["dvrs_pending"]
    @entery_date = Time.parse("#{params["entery_date"]}").try(:to_date) rescue nil
    
    @user_id = current_api_user.id
    @district_id = current_api_user.district_id
    @district_name = current_api_user.get_district.try(:district_name)
    @version_code = params[:version_code]
  end
  
  def call
    begin
      dengue_situation = DengueSituation.new(generate_json)
      if dengue_situation.save
        return true
      else
        errors.add :base, "#{dengue_situation.errors.full_messages.to_sentence}"
      end
    rescue => e
      errors.add :base, "#{e.message}"
    end
    nil
  end
  
  private
  
  attr_accessor :confirmed_patient, :patient_reported_by_lab, :patient_reported_by_hospital, :death, :admissions, :case_reponse, :indoor_positive_larvae, :outdoor_positive_larvae, :hotspots_coverage, :dormant_users, :firs, :notices_served, :premises_sealed, :arrests, :fines_imposed, :dvrs_total, :dvrs_resolved, :dvrs_pending, :entery_date, :user_id, :district_id, :district_name, :version_code

  def generate_json
    {
      confirmed_patient: confirmed_patient,
      patient_reported_by_lab: patient_reported_by_lab,
      patient_reported_by_hospital: patient_reported_by_hospital,
      death: death,
      admissions: admissions,
      case_reponse: case_reponse,
      indoor_positive_larvae: indoor_positive_larvae,
      outdoor_positive_larvae: outdoor_positive_larvae,
      hotspots_coverage: hotspots_coverage,
      dormant_users: dormant_users,
      firs: firs,
      notices_served: notices_served,
      premises_sealed: premises_sealed,
      arrests: arrests,
      fines_imposed: fines_imposed,
      dvrs_total: dvrs_total,
      dvrs_resolved: dvrs_resolved,
      dvrs_pending: dvrs_pending,
      entery_date: entery_date,
      user_id: user_id,
      district_id: district_id,
      district_name: district_name,
      version_code: version_code
    }
  end
end


