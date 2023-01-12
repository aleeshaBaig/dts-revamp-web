class CreateZeroPatients < ActiveRecord::Migration[6.0]
  def change
    create_table :zero_patients do |t|
      t.integer :user_id
      t.integer :hospital_id
      t.string :hospital
      t.integer :district_id
      t.string :district
      t.integer :t_type, default: 0
      t.timestamps
    end
    add_index :zero_patients, :user_id
    add_index :zero_patients, :hospital_id
    add_index :zero_patients, :district_id
  end
end
