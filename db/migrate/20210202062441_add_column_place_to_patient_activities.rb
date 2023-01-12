class AddColumnPlaceToPatientActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :patient_activities, :patient_place, :integer
    add_index :patient_activities, :patient_place
  end
end
