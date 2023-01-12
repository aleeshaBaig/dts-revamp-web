class AddColumnDistrictToPatientActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :patient_activities, :district_id, :integer
    add_column :patient_activities, :district_name, :string
  end
end
