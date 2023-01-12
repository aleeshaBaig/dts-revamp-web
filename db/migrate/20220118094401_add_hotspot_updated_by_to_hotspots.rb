class AddHotspotUpdatedByToHotspots < ActiveRecord::Migration[6.0]
  def change
    add_column :hotspots, :hotspot_updated_by, :int
  end
end