class RemoveColumnHospIdToUsers < ActiveRecord::Migration[6.0]
  def change
  	remove_column :users, :hosp_id
  end
end
