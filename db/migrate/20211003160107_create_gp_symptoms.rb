class CreateGpSymptoms < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_symptoms do |t|
      t.boolean :fever
      t.date :fever_date
      t.integer :associate_symptom
      t.integer :gp_dengue_patient_id

      t.timestamps
    end
    add_index :gp_symptoms, :gp_dengue_patient_id
  end
end
