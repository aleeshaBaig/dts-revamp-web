class AddColumnIsPasswordChangedToMobileUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :mobile_users, :is_forgot, :boolean, default: false
  end
end
