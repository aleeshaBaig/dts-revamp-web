class AddColumnDescriptionToPatientActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :patient_activities, :description, :text
  end
end
