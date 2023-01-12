class AddTagIdToHotspots < ActiveRecord::Migration[6.0]
  def change
    add_column :hotspots, :tag_id, :integer
  end
end
