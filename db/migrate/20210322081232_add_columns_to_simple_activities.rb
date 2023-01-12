class AddColumnsToSimpleActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :simple_activities, :department_id, :integer
    add_column :simple_activities, :department_name, :string
  end
end
