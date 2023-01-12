class AddIsLoggedInToMobileUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :mobile_users, :is_logged_in, :boolean
  end
end
