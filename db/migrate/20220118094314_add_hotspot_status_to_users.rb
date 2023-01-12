class AddHotspotStatusToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :hotspot_status, :boolean
  end
end