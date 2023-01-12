class AddColumnProvinceIdToSimpleActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :simple_activities, :province_id, :integer
  end
end
