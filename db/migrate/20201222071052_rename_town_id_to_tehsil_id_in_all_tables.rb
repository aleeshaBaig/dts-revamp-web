class RenameTownIdToTehsilIdInAllTables < ActiveRecord::Migration[6.0]
  def up
  	rename_column :hotspots, :town, :tehsil
  	rename_column :hotspots, :town_id, :tehsil_id
  	rename_column :mobile_users, :town, :tehsil
  	rename_column :mobile_users, :town_id, :tehsil_id
  end

  def down
  	rename_column :hotspots, :tehsil, :town
  	rename_column :hotspots, :tehsil_id, :town_id
  	rename_column :mobile_users, :tehsil, :town
  	rename_column :mobile_users, :tehsil_id, :town_id
  end
end
