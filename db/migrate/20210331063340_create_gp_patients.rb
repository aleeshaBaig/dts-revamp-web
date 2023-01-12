class CreateGpPatients < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_patients do |t|
      t.integer :user_id
      t.datetime :reporting_date
      t.string :patient_name
      t.string :fh_name
      t.string :dob
      t.integer :age
      t.float :age_month
      t.string :gender
      t.string :cnic
      t.string :phone_number
      t.string :district
      t.string :town_tehsil
      t.string :uc_name
      t.string :occupation
      t.string :lat
      t.string :long
      t.date :onset_date_fever
      t.boolean :prev_dengue_fever
      t.boolean :fever
      t.boolean :warning_signs
      t.string :provisional_diagnosis
      t.string :igg_performed
      t.string :igm_performed
      t.string :antigen_performed
      t.integer :wbc_first_reading
      t.date :wbc_first_date
      t.string :dengue_type
      t.string :diagnosis
      t.string :patient_status
      t.text :comments
      t.string :patient_type
      t.string :patient_condition
      t.string :street_no_name
      t.string :house_no
      t.string :viral_detection_performed
      t.string :hospital_name
      t.string :locality
      t.boolean :is_app_user
      t.string :residence_address
      t.string :workplace_address
      t.string :reffer_to
      t.string :symptoms
      t.string :platelets_reading
      t.date :platelets_date
      t.string :vitals
      t.boolean :headache
      t.boolean :retro_orbital_pain
      t.boolean :myalgia
      t.boolean :arthralgia_backache
      t.boolean :irritability_in_infants
      t.boolean :rash
      t.boolean :bleeding_manisfestations
      t.boolean :severe_abdominal_pain
      t.boolean :decreased_urinary_output
      t.integer :temprature
      t.integer :hr
      t.integer :bp_s
      t.integer :bp_d
      t.string :refered_to_confirmed
      t.string :probable_patient_status
      t.string :probable_comments
      t.string :present_address
      t.boolean :has_fever
      t.string :pp
      t.boolean :wbc1lessthan4000
      t.boolean :platelets_less_than_lakh
      t.boolean :no_clinical_improvement
      t.boolean :persistent_vomiting
      t.boolean :lethargy_restlessness
      t.boolean :giddiness
      t.boolean :clammy_extremities
      t.boolean :bleeding_epistaxis
      t.boolean :hematemesis
      t.boolean :hct
      t.boolean :pulse_pressure
      t.boolean :no_urine_output
      t.date :ns1_reading_date
      t.string :detection_by_pcr
      t.date :pcr_detection_date
      t.date :igm_reading_date
      t.date :igg_reading_date
      t.boolean :df
      t.boolean :dhf
      t.boolean :dss

      t.timestamps
    end
  end
end
