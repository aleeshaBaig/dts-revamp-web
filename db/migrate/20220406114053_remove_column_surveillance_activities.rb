class RemoveColumnSurveillanceActivities < ActiveRecord::Migration[6.0]
  def up
    remove_column :surveillance_activities, :checked_val
    remove_column :surveillance_activities, :positive_val
    remove_column :surveillance_activities, :total_checked
    remove_column :surveillance_activities, :total_positive
    remove_column :surveillance_activities, :surveillance_tag_id
    remove_column :surveillance_activities, :surveillance_tag_name
  end
  def down
    add_column :surveillance_activities, :checked_val, :integer
    add_column :surveillance_activities, :positive_val, :integer
    add_column :surveillance_activities, :total_checked, :integer
    add_column :surveillance_activities, :total_positive, :integer
    add_column :surveillance_activities, :surveillance_tag_id, :integer
    add_column :surveillance_activities, :surveillance_tag_name, :string
  end
end
