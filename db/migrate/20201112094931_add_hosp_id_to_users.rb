class AddHospIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :hosp_id, :integer
  end
end
