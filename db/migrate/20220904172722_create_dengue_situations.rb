class CreateDengueSituations < ActiveRecord::Migration[6.0]
  def change
    create_table :dengue_situations do |t|
      t.integer :confirmed_patient
      t.integer :patient_reported_by_lab
      t.integer :patient_reported_by_hospital
      t.integer :death
      t.integer :admissions
      t.integer :case_reponse
      t.integer :indoor_positive_larvae
      t.integer :outdoor_positive_larvae
      t.integer :hotspots_coverage
      t.integer :dormant_users
      t.integer :firs
      t.integer :notices_served
      t.integer :premises_sealed
      t.integer :arrests
      t.integer :fines_imposed
      t.integer :dvrs_total, limit: 8
      t.integer :dvrs_resolved
      t.integer :dvrs_pending
      t.date :entery_date, default: Time.now.to_date
      t.integer :user_id
      t.integer :district_id
      t.string :district_name

      t.timestamps
    end
    add_index :dengue_situations, :entery_date, using: 'BRIN'
  end
end
