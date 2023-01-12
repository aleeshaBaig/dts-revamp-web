class AddStatusToMobileUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :mobile_users, :status, :boolean
  end
end
