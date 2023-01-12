class AddDistrictIdToSimpleActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :simple_activities, :district_id, :integer
  end
end
