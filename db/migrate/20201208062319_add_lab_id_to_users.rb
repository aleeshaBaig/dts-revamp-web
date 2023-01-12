class AddLabIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lab_id, :integer
  end
end
