json.extract! patient, :id, :patient_name, :fh_name, :age, :age_month, :gender, :cnic, :cnic_relation, :patient_contact, :relation_contact, :address, :district, :district_id, :tehsil, :tehsil_id, :uc, :uc_id, :permanent_address, :permanent_district, :permanent_district_id, :permanent_tehsil, :permanent_tehsil_id, :permanent_uc, :permanent_uc_id, :workplace_address, :workplace_district, :workplace_district_id, :workplace_tehsil, :workplace_tehsil_id, :workplace_uc, :workplace_uc_id, :date_of_onset, :fever_last_till, :fever, :previous_dengue_fever, :associated_symptom, :provisional_diagnosis, :other_diagnosed_fever, :patient_status, :patient_outcome, :patient_condition, :hospital, :hospital_id, :user_id, :username, :created_at, :updated_at
json.url patient_url(patient, format: :json)
