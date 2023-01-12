class AddIdentificationColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    add_index :users, :username
    add_column :users, :role, :string
    add_column :users, :sub_role, :string
  end
end
