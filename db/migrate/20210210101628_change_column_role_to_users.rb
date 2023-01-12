class ChangeColumnRoleToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :role, :integer
  	add_index :users, :role
  end
end
