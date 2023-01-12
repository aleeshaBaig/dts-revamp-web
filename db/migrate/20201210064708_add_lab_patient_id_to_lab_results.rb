class AddLabPatientIdToLabResults < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_results, :lab_patient_id, :integer
  end
end
