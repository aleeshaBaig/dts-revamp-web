class AddIsBogusToSimpleActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :simple_activities, :is_bogus, :boolean
  end
end
