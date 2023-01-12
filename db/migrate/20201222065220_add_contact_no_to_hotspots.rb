class AddContactNoToHotspots < ActiveRecord::Migration[6.0]
  def change
    add_column :hotspots, :contact_no, :string
  end
end
