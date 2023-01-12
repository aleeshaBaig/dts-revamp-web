class AddColumnProvinceIdToPatientActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :patient_activities, :province_id, :integer
  end
end
