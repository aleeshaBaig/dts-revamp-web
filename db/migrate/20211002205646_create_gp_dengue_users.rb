class CreateGpDengueUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_dengue_users do |t|
      t.string "email", unique: true
      t.string "password_digest"
      t.string "name"
      t.string "clinic_name"
      t.string "contact_no", unique: true
      t.string "pmdc_number", unique: true
      t.integer "role"
      
      t.integer "district_id"
      t.string "district_name"
      
      t.integer "tehsil_id"
      t.string "tehsil_name"

      t.integer "uc_id"
      t.string "uc_name"
      
      t.integer "hospital_id"
      t.string "hospital_name"

      t.text "address"
      t.string "city_name"
      t.string "lat"
      t.string "lng"
      t.boolean "status", default: true
      t.boolean "is_logged_in", default: true
      t.timestamps
    end
    
    add_index :gp_dengue_users, :email, unique: true
    add_index :gp_dengue_users, :pmdc_number, unique: true
    add_index :gp_dengue_users, :contact_no, unique: true
    add_index :gp_dengue_users, :role
    add_index :gp_dengue_users, :district_id
    add_index :gp_dengue_users, :tehsil_id
    add_index :gp_dengue_users, :uc_id
    add_index :gp_dengue_users, :hospital_id
  end
end
