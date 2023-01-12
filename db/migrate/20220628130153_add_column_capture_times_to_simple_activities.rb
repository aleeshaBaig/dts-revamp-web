class AddColumnCaptureTimesToSimpleActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :simple_activities, :pb_time, :datetime
    add_column :simple_activities, :pa_time, :datetime
    add_column :simple_activities, :pdif_time, :integer, default: 0
  end
end
