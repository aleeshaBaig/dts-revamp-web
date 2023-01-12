class AddColumnDepartmentIdToPatientActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :patient_activities, :department_id, :integer
    add_column :patient_activities, :department_name, :string
  end
end
