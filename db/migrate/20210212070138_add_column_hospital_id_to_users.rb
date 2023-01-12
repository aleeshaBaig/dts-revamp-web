class AddColumnHospitalIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :hospital_id, :integer
    
    add_index :users, :hospital_id
    add_index :users, [:district_id, :hospital_id]
  end
end
