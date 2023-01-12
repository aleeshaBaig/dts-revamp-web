class CreateBeds < ActiveRecord::Migration[6.0]
  def change
    create_table :beds do |t|
      t.integer :total_ward_beds, limit: 8, default: 0
      t.integer :occupied_ward_beds, limit: 8, default: 0
      t.integer :total_hdu_beds, limit: 8, default: 0
      t.integer :occupied_hdu_beds, limit: 8, default: 0
      t.integer :hospital_id

      t.timestamps
    end
    
    add_index :beds, :hospital_id
  end
end
