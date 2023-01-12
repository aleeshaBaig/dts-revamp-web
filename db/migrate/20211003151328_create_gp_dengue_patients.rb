class CreateGpDenguePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_dengue_patients do |t|
      t.integer :gp_dengue_user_id
      t.string :patient_name
      t.string :fh_name
      t.integer :gender
      t.integer :age
      t.integer :age_month
      t.string :dob
      t.string :cnic
      t.string :contact_no
      t.integer :provisional_diagnosis ## [suspected,probable, confirmed]
      t.integer :lab_id
      t.integer :hospital_id
      t.integer :reffer_type ## [lab, hospitals]
      t.string :app_version
      t.datetime :activity_time
      t.float :lat
      t.float :lng
      t.string :before_picture
      t.string :after_picture
      t.timestamps
    end
    add_index :gp_dengue_patients, :cnic, unique: true
    add_index :gp_dengue_patients, :contact_no
    add_index :gp_dengue_patients, :provisional_diagnosis
    add_index :gp_dengue_patients, :reffer_type
  end
end
