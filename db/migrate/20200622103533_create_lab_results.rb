class CreateLabResults < ActiveRecord::Migration[6.0]
  def change
    create_table :lab_results do |t|
      t.integer :hcc_first_reading
      t.integer :wbc_first_reading
      t.integer :platelet_first_reading
      t.integer :hct_second_reading
      t.integer :wbc_second_reading
      t.integer :platelet_second_reading
      t.boolean :warning_signs
      t.string :ns1
      t.string :pcr
      t.string :igm
      t.string :igg
      t.string :diagnosis
      t.string :dengue_virus_type
      t.integer :patient_id

      t.timestamps
    end
  end
end
