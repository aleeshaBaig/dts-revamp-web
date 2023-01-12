class AddColumnIsTaggedToHotspots < ActiveRecord::Migration[6.0]
  def change
    add_column :hotspots, :is_tagged, :integer, default: 0
  end
end
