class CreateGpLabDiagnostices < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_lab_diagnostices do |t|
      t.integer :ns1
      t.date :ns1_date
      t.integer :pcr
      t.date :pcr_date
      t.date :sero_type
      t.integer :igm
      t.date :igm_date
      t.integer :igg
      t.date :igg_date
      t.integer :dengue_fever_type
      t.integer :gp_dengue_patient_id

      t.timestamps
    end
    add_index :gp_lab_diagnostices, :gp_dengue_patient_id
  end
end
