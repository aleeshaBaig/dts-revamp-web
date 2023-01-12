json.set! :data do
  json.array! @dengue_situations do |dengue_situation|
    json.id dengue_situation.id
    json.confirmed_patient dengue_situation.confirmed_patient
    json.patient_reported_by_lab dengue_situation.patient_reported_by_lab
    json.patient_reported_by_hospital dengue_situation.patient_reported_by_hospital
    json.death dengue_situation.death
    json.admissions dengue_situation.admissions
    json.case_reponse dengue_situation.case_reponse
    json.indoor_positive_larvae dengue_situation.indoor_positive_larvae
    json.outdoor_positive_larvae dengue_situation.outdoor_positive_larvae
    json.hotspots_coverage dengue_situation.hotspots_coverage
    json.dormant_users dengue_situation.dormant_users
    json.firs dengue_situation.firs
    json.notices_served dengue_situation.notices_served
    json.premises_sealed dengue_situation.premises_sealed
    json.arrests dengue_situation.arrests
    json.fines_imposed dengue_situation.fines_imposed
    json.dvrs_total dengue_situation.dvrs_total
    json.dvrs_resolved dengue_situation.dvrs_resolved
    json.dvrs_pending dengue_situation.dvrs_pending
    json.district_name dengue_situation.district_name
    json.entery_user dengue_situation.user.try(:username)
    json.entery_date dengue_situation.entery_date.try(:to_date).try(:strftime, "%m/%d/%Y")
    json.created_at dengue_situation.created_at.to_datetime.strftime("%m/%d/%Y")
  end
end