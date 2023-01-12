class ChangeColumnProvisionalDiagnosisToLabPatients < ActiveRecord::Migration[6.0]
  def change
  	remove_column :lab_patients, :provisional_diagnosis
  	add_column :lab_patients, :provisional_diagnosis, :integer
  end
end
