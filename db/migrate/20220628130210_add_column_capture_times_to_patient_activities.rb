class AddColumnCaptureTimesToPatientActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :patient_activities, :pb_time, :datetime
    add_column :patient_activities, :pa_time, :datetime
    add_column :patient_activities, :pdif_time, :integer, default: 0
  end
end
