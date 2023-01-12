class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :patient_name
      t.string :fh_name
      t.integer :age
      t.integer :age_month
      t.string :gender
      t.string :cnic
      t.string :cnic_relation
      t.string :patient_contact
      t.string :relation_contact
      t.text :address
      t.string :district
      t.integer :district_id
      t.string :tehsil
      t.integer :tehsil_id
      t.string :uc
      t.integer :uc_id
      t.text :permanent_address
      t.string :permanent_district
      t.integer :permanent_district_id
      t.string :permanent_tehsil
      t.integer :permanent_tehsil_id
      t.string :permanent_uc
      t.integer :permanent_uc_id
      t.text :workplace_address
      t.string :workplace_district
      t.integer :workplace_district_id
      t.string :workplace_tehsil
      t.integer :workplace_tehsil_id
      t.string :workplace_uc
      t.integer :workplace_uc_id
      t.date :date_of_onset
      t.date :fever_last_till
      t.boolean :fever
      t.boolean :previous_dengue_fever
      t.boolean :associated_symptom
      t.integer :provisional_diagnosis
      t.string :other_diagnosed_fever
      t.integer :patient_status
      t.integer :patient_outcome
      t.integer :patient_condition
      t.string :hospital
      t.integer :hospital_id
      t.integer :user_id
      t.string :username

      t.timestamps
    end
  end
end
