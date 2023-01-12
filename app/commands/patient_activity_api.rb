class PatientActivityApi
  prepend SimpleCommand
  include ApplicationHelper
  include ActiveModel::Validations
  
   def initialize(params, before_picture, after_picture, current_api_user)
    @tag_category_id = params["category_id"]
    @tag_category_name = params["category_name"]
    
    ## YES/NO VALUE
    @awareness = get_truefalse(params["awareness"])
    @removal_bleeding_spot = get_truefalse(params["removal_bleeding_spot"])
    @elimination_bleeding_spot = get_truefalse(params["elimination_bleeding_spot"])
    @patient_spray = get_truefalse(params["patient_spray"])

    @comment = params["comment"]
    @tag_name = params["tag_name"]
    @tag_id = Tag.where("m_tag_id = ?", params["tag_id"]).last.id
    @app_version = params["app_version"]
    @latitude = params["latitude"]
    @longitude = params["longitude"]
    @activity_time = Time.parse("#{params["activity_time"]}").try(:to_datetime) rescue nil
    @os_version_number = params["os_version_number"]
    @os_version_name = params["os_version_name"]
    @user_id = params["user_id"]
    @patient_id = params["patient_id"]
    @uc_name = params["uc_name"]
    @uc_id = params["uc_id"]
    @tehsil_name = params["town_name"]
    @tehsil_id = params["town_id"]
    @patient_place = params["patient_place"]
    @department_id = current_api_user.department_id
    @department_name = current_api_user.department.try(:department_name)
    
    @district_id = current_api_user.district_id
    @district_name = current_api_user.get_district.try(:district_name)

    ## Picture Captured Time
    @pb_time = params["pb_time"]
    @pa_time = params["pa_time"]
    @pdif_time = params["pdif_time"] ## store in seconds

    ## workplaces
    @residence_tagged = get_truefalse(params["residence_tagged"])
    @workplace_tagged = get_truefalse(params["workplace_tagged"])
    @permanent_residence_tagged = get_truefalse(params["permanent_residence_tagged"])

    @before_picture = before_picture ||= nil
    @after_picture = after_picture ||= nil
    
  end
  
  def call
    begin
      patient = Patient.find_by(id: patient_id)
      if patient.present?
          if ((patient.residence_tagged != true and patient_place == "residence") or (patient.workplace_tagged != true and patient_place == "workplace") or (patient.permanent_residence_tagged != true and patient_place == "permanent") or tag_name.downcase != "patient")
            patient_activity = PatientActivity.new(generate_json)
            patient_activity.provisional_diagnosis = patient.provisional_diagnosis
            patient_activity.description = patient.get_address(patient_place)
            ## transactions
            ActiveRecord::Base.transaction do
              if patient_activity.save
                picture = patient_activity.save_picture(before_picture, after_picture)
                patient_activity.before_picture = picture.before_picture.url
                patient_activity.after_picture = picture.after_picture.url
                if patient_activity.save
                  (patient.comments = "N/A") unless patient.comments.present?
                  ## if Tag Name: patient irs
                  if patient_activity.is_patient_irs?
                    ## patient house hold tags
                    patient.tag_increment(patient_place)
                    patient.save(validate: false)
                  ## if Tag Name: Patient >> tagged workplace, residence , permament
                  elsif patient_activity.is_irs_patient?
                    case patient_place
                    when 'residence'
                      patient.residence_tagged = true
                    when 'workplace'
                      patient.workplace_tagged = true
                    when 'permanent'
                      patient.permanent_residence_tagged = true
                    end                   
                    if patient.save(validate: false)
                      return true
                    else
                      errors.add :base, "#{patient.errors.full_messages.to_sentence}"
                      raise ActiveRecord::Rollback
                    end
                  end
                end

                return patient_activity
              else
                errors.add :base, "#{patient_activity.errors.full_messages.to_sentence}"
              end
            end
          else
            errors.add :base, "Patient is already tagged"
          end

      else
        errors.add :base, "Patient not found"
      end
    rescue => e
      errors.add :base, "#{e.message}"
    end
    nil
  end
  
  private
  
  attr_accessor :patient_place, :residence_tagged, :workplace_tagged, :permanent_residence_tagged, :tag_category_id, :tag_category_name, :awareness, :removal_bleeding_spot, :elimination_bleeding_spot, :patient_spray, :comment, :tag_name, :tag_id, :app_version, :latitude, :longitude, :activity_time, :os_version_number, :os_version_name, :user_id, :patient_id, :uc_name, :uc_id, :tehsil_name, :tehsil_id, :before_picture, :after_picture, :department_id, :department_name, :district_id, :district_name, :pb_time, :pa_time, :pdif_time

  def generate_json
    {
      tag_category_id: tag_category_id,
      tag_category_name: tag_category_name,
      awareness: awareness,
      removal_bleeding_spot: removal_bleeding_spot,
      elimination_bleeding_spot: elimination_bleeding_spot,
      patient_spray: patient_spray,
      comment: comment,
      tag_name: tag_name,
      tag_id: tag_id,
      app_version: app_version,
      latitude: latitude,
      longitude: longitude,
      activity_time: activity_time,
      os_version_number: os_version_number,
      os_version_name: os_version_name,
      user_id: user_id,
      patient_id: patient_id,
      uc_name: uc_name,
      uc_id: uc_id,
      tehsil_name: tehsil_name,
      tehsil_id: tehsil_id,
      patient_place: patient_place,
      department_id: department_id,
      department_name: department_name, 
      district_id: district_id,
      district_name: district_name,
      pb_time: pb_time,
      pa_time: pa_time,
      pdif_time: pdif_time
    }
  end
end