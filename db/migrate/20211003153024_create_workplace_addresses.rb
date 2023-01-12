class CreateWorkplaceAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :workplace_addresses do |t|
      t.integer :district_id
      t.string :district_name
      t.integer :tehsil_id
      t.string :tehsil_name
      t.integer :uc_id
      t.string :uc_name
      t.integer :gp_dengue_patient_id
      t.text :address
      t.timestamps
    end
    add_index :workplace_addresses, :district_id
    add_index :workplace_addresses, :tehsil_id
    add_index :workplace_addresses, :uc_id
    add_index :workplace_addresses, :gp_dengue_patient_id
  end
end
