class AddColumnLastVisitedToHotspots < ActiveRecord::Migration[6.0]
  def change
    add_column :hotspots, :last_visited, :datetime
  end
end
