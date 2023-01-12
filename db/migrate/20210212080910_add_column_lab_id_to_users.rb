class AddColumnLabIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :lab_id
    add_index :users, [:district_id, :lab_id]
  end
end
