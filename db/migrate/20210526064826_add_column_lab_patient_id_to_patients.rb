class AddColumnLabPatientIdToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :lab_patient_id, :integer
    add_index :patients, :lab_patient_id
  end
end
