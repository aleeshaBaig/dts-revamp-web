class AddColumnStatusToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :status
    add_column :users, :status, :boolean, default: true
  end
end
