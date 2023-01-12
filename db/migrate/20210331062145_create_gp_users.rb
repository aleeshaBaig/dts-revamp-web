class CreateGpUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_users do |t|
      t.string :name
      t.string :clinic
      t.string :contact_no
      t.string :district
      t.text :address
      t.string :city_name
      t.string :division
      t.string :doctor_name
      t.string :email
      t.string :facility_type
      t.string :hospital
      t.boolean :is_mobile_signup
      t.string :lat
      t.string :lng
      t.string :password
      t.string :pmdc_number
      t.string :tehsil

      t.timestamps
    end
    add_index :gp_users, :name
    add_index :gp_users, :district
    add_index :gp_users, :doctor_name
    add_index :gp_users, :email
    add_index :gp_users, :facility_type
    add_index :gp_users, :is_mobile_signup
    add_index :gp_users, :password
    add_index :gp_users, :pmdc_number
  end
end
