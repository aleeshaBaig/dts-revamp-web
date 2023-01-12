class AddColumnProvisionalDiagnosisToPatientActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :patient_activities, :provisional_diagnosis, :integer
    add_index :patient_activities, :provisional_diagnosis
  end
end
