class AddUserIdToNewModels < ActiveRecord::Migration[6.0]
  def change
    add_column :medicine_stocks, :user_id, :integer
    add_column :ppe_stocks, :user_id, :integer
    add_column :pcr_machines, :user_id, :integer
    add_column :insecticide_stocks, :user_id, :integer
  end
end
