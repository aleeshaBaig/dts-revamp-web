class AddOldUserIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :old_user_id, :integer
  end
end
