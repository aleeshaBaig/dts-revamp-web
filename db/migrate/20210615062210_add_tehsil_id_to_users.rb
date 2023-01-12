class AddTehsilIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tehsil_id, :integer
  end
end
