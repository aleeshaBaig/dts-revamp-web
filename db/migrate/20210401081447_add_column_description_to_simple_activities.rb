class AddColumnDescriptionToSimpleActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :simple_activities, :description, :text
  end
end
