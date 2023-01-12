json.set! :data do
  json.array! @gp_dengue_patients do |gp_dengue_patient|
    json.partial! 'gp_dengue_patients/gp_dengue_patient', gp_dengue_patient: gp_dengue_patient
    json.url  "
              #{link_to 'Show', gp_dengue_patient }
              #{link_to 'Edit', edit_gp_dengue_patient_path(gp_dengue_patient)}
              #{link_to 'Destroy', gp_dengue_patient, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end