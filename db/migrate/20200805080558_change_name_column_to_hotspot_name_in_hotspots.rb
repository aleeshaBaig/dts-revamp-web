class ChangeNameColumnToHotspotNameInHotspots < ActiveRecord::Migration[6.0]
  def change
  	rename_column :hotspots, :name, :hotspot_name
  end
end
