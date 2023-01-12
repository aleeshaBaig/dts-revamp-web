class CreateGpLabResults < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_lab_results do |t|
      t.integer :hct_first_reading
      t.date :hct_reading_date
      t.integer :wbc_first_reading
      t.date :wbc_reading_date
      t.integer :platelet_first_reading
      t.date :platelet_reading_date
      t.integer :warning_sign
      t.integer :gp_dengue_patient_id

      t.timestamps
    end
    add_index :gp_lab_results, :gp_dengue_patient_id
  end
end
